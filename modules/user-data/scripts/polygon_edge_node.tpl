#!/bin/bash
POLYGON_FOLDER="${polygon_edge_dir}"
LOGS_FOLDER="${polygon_edge_dir}/logs"
DATA_FOLDER="${polygon_edge_dir}/data"
EBS_DEVICE="${ebs_device}"
LOG_FILE="$LOGS_FOLDER/init.log"
NODE_INIT_FILE="$LOGS_FOLDER/node_init.json"
LINUX_USER="ubuntu"
NODE_NAME="${node_name}"
ASSM_PARAM_PATH="/${assm_path}"
ASSM_REGION="${assm_region}"
IP="$(hostname -I)"

TOTAL_NODES="${total_nodes}"

# create central dir that will hold chain data and logs
if [ ! -d "$POLYGON_FOLDER" ];
then
mkdir "$POLYGON_FOLDER"
fi
# crate logs dir
if [ ! -d "$LOGS_FOLDER" ];
then
mkdir "$LOGS_FOLDER"
fi

echo "----------- Script starting on :$(date) ----------------" >> "$LOG_FILE"
## Check if data directory already exists
if [ -d "$DATA_FOLDER" ];
then
        echo "$DATA_FOLDER direcotory is already created. Skipping directory creation..." >> "$LOG_FILE"
else
        ERR=$(mkdir "$DATA_FOLDER" 2>&1 > /dev/null)
        [ $? -eq 0 ] && echo "Data directory created!" >> "$LOG_FILE" || echo "Directory creation failed! Error: $ERR" >> "$LOG_FILE"
fi

# Wait for the system to fully boot before attemting to mount the EBS
counter=0
while [ ! -b "$EBS_DEVICE" ]; 
do
    sleep 10
    counter=$((counter + 1))
    if [ $counter -ge 30 ]; 
    then
        echo "Could not initialize $EBS_DEVICE for more than 5 minutes. Exiting ...">> "$LOG_FILE"
        exit 1
    fi
done

# Check if EBS storage exists
if [ -b "$EBS_DEVICE" ];
then
        # Check if we already have a filesystem on $EBS_DEVICE. If not create one.
        if [[ $(file -s "$EBS_DEVICE") == "$EBS_DEVICE: data" ]];
        then
                ERR=$(mkfs -t xfs "$EBS_DEVICE" 2>&1 > /dev/null)
                [ $? -eq 0 ] && echo "EBS volume successfuly formated" >> "$LOG_FILE" || echo "Error formating EBS volume. ERR: $ERR" >> "$LOG_FILE"
        else
                echo "$EBS_DEVICE already has a file system! Skipping... ">> "$LOG_FILE"
        fi
        # If block ebs device exists and it has a filesystem, check if it is mounted and mount if it is not already mounted
        if grep -qs "$EBS_DEVICE" /proc/mounts;
        then
                echo "EBS Volume already mounted. Skipping..." >> "$LOG_FILE"
        else
                # Mount EBS volume
                mount "$EBS_DEVICE" "$DATA_FOLDER"
                [ $? -eq 0 ] && echo "EBS Volume successfuly mounted!" >> "$LOG_FILE"
                ## Edit fstab
                echo "$EBS_DEVICE   $DATA_FOLDER    xfs     defaults,nofail     0 2" >> /etc/fstab
                [ $? -eq 0 ] && echo "Fstab successfuly edited. EBS Volume added." >> "$LOG_FILE" || echo "Fstab EBS volume edit failed!" >> "$LOG_FILE"
                ## Set right permissions for ubuntu user
                chown -R "$LINUX_USER". "$DATA_FOLDER"
                [ $? -eq 0 ] && echo "User permissions on $DATA_FOLDER set..." >> $LOG_FILE || echo "Could not set $DATA_FOLDER permissions!"
        fi
else
        echo "No EBS Volume detected! Check if it is attached and/or if it is mounted on $EBS_DEVICE" >> "$LOG_FILE"
fi

echo "--------------------------------------------------------------" >> "$LOG_FILE"
echo "Getting polygon-edge binary ..." >> "$LOG_FILE"

# wait for system to fully boot
sleep 60

# install packages
sudo apt update && sudo apt install -y jq awscli

# get polygon-edge binary from github releases #77894422 - v0.5.1
mkdir /tmp/polygon-edge
wget -q -O /tmp/polygon-edge/polygon-edge.tar.gz "$(curl -s https://api.github.com/repos/0xPolygon/polygon-edge/releases/84686590 | jq .assets[3].browser_download_url  | tr -d '"')"
tar -xvf /tmp/polygon-edge/polygon-edge.tar.gz -C /tmp/polygon-edge
sudo mv /tmp/polygon-edge/polygon-edge /usr/local/bin/
rm -R /tmp/polygon-edge


# create json lambda query
jsonLambda=$(cat <<EOF
{
  "config": {
	  "aws_region": "$ASSM_REGION",
	  "s3_bucket_name": "${s3_bucket_name}",
	  "s3_key_name": "${s3_key_name}",

    "premine": "${premine}",
    "chain_name": "${chain_name}",
	  "chain_id": "${chain_id}",
	  "pos": ${pos},
	  "epoch_size": "${epoch_size}",
	  "block_gas_limit": "${block_gas_limit}",
	  "max_validator_count": "${max_validator_count}",
	  "min_validator_count": "${min_validator_count}",
	  "consensus": "${consensus}"
  },
  "nodes": {
	  "total": $TOTAL_NODES,
	  "node_info": {
      "ssm_param_id": "${assm_path}",
        "node_name": "$NODE_NAME",
        "ip": "$IP"
	  }
  }
}
EOF
)

echo "--------------------------------------------------------------" >> "$LOG_FILE"
echo "System init complete. Starting node initialization ..." >> "$LOG_FILE"

# Check if data folder is empty
if [ "$(ls -A "$DATA_FOLDER")" ]; then
        echo "Files in data dir found. Skipping Polygon edge initialization..." >> "$LOG_FILE"
else
        echo "Starting node initialization" >> "$LOG_FILE"
        /usr/local/bin/polygon-edge secrets generate --type aws-ssm --name "$NODE_NAME" --extra region="$ASSM_REGION",ssm-parameter-path="$ASSM_PARAM_PATH" --dir "$DATA_FOLDER/secretsConfig.json"
        POLYGON=$(/usr/local/bin/polygon-edge secrets init --config "$DATA_FOLDER"/secretsConfig.json --json 2>&1)
        # Check if everything went ok
        if [ $? -eq 0 ]; then
            aws lambda invoke --function-name "${lambda_function_name}" --region "$ASSM_REGION" --payload "$jsonLambda" "$LOGS_FOLDER/lambda.json"
        else
                echo "The initialization of polygon edge failed. Check log @ $LOG_FILE" >> "$LOG_FILE"
                echo "$POLYGON" >> "$LOG_FILE"
        fi
fi

chown -R "$LINUX_USER". "$POLYGON_FOLDER"

echo "ALL DONE!" >> "$LOG_FILE"
echo "-------- Finished on: $(date)  ----------" >> "$LOG_FILE"
exit 0
