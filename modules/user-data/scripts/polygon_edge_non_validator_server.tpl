#!/bin/bash
DATA_DIR="${polygon_edge_dir}/data"
SECRETS_FILE="$DATA_DIR/secretsConfig.json"
GENESIS_FILE="$DATA_DIR/genesis.json"
S3_GENESIS="${s3_bucket_name}/genesis.json"
LOG_FILE="${polygon_edge_dir}/logs/edge-server.log"

# install awscli so that we can fetch genesis.json
sudo apt update && sudo apt install -y awscli

# wait untill genesis.json is found in the S3 bucket
while ! aws s3 ls ${s3_bucket_name} | grep genesis.json > /dev/null;
do
  echo "Waiting for genesis.json to appear in S3 bucket..."
  sleep 10
done

# we found genesis.json, now we download it to data folder
aws s3 cp s3://$S3_GENESIS $DATA_DIR


# Create polygon-edge service and start it after genesis.json file is detected
cat > /etc/systemd/system/polygon_genesis.target << EOF
# check if genesys.json exists
[Unit]
TimeoutStartSec=infinity
ConditionPathExists=$GENESIS_FILE
ExecStart=/usr/bin/sleep 5
RemainAfterExit=yes
EOF

## TODO make server options customisable
cat > /etc/systemd/system/polygon-edge.service << EOF
[Unit]
Description=Polygon Edge Server
After=network.target polygon_genesis.target
Wants=polygon_genesis.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=10
User=ubuntu
StandardOutput=syslog
StandardError=file:$LOG_FILE
ExecStartPre=/bin/bash -c "sudo rm $LOG_FILE"
ExecStart=polygon-edge server --data-dir ./home/ubuntu/polygon/data/ --chain genesis.json --libp2p 0.0.0.0:1478 --nat ${nat_address}

[Install]
WantedBy=multi-user.target
EOF

#### customise server options

# enable Prometheus API
if [ "${prometheus_address}" != "" ]; then
  prometheus="--prometheus ${prometheus_address}"
fi

# set block gas limit
if [ "${block_gas_target}" != "" ]; then
  block_gas_target="--block-gas-target ${block_gas_target}"
fi

# set nated address
if [ "${nat_address}" != "" ]; then
 nat="--nat ${nat_address}"
fi

# set dns name
if [ "${dns_name}" != "" ]; then
 dns_name="--dns ${dns_name}"
fi

# set price limit
if [ "${price_limit}" != "" ]; then
 price_limit="--price-limit ${price_limit}"
fi

# set max slots
if [ "${max_slots}" != "" ]; then
 max_slots="--max-slots ${max_slots}"
fi

# set block time in seconds
if [ "${block_time}" != "" ]; then
  block_time="--block-time ${block_time}"
fi

# set these parameters in service file
sed -i "s/SERVER_OPTIONS/$prometheus $block_gas_target $nat $dns $price_limit $max_slots $block_time/g" /etc/systemd/system/polygon-edge.service

# change ownership of the polygon folder to ubuntu user
sudo chown -R ubuntu. ${polygon_edge_dir}

# Enable polygon-edge on startup
sudo /usr/bin/systemctl enable polygon-edge.service

# Start polygon-edge service
sudo /usr/bin/systemctl start polygon-edge.service