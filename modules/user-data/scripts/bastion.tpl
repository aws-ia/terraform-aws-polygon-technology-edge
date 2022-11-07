#!/bin/bash

## Create private key that we use to login to Polygon-SDK instances
cat > /home/ubuntu/.ssh/id_ecdsa << EOF
${bastion_private_key}
EOF

# wait for the system to fully boot
sleep 30

# get polygon-edge binary from github releases
sudo apt update && sudo apt install -y jq
mkdir /tmp/polygon-edge
wget -q -O /tmp/polygon-edge/polygon-edge.tar.gz $(curl -s https://api.github.com/repos/0xPolygon/polygon-edge/releases/latest | jq .assets[3].browser_download_url  | tr -d '"')
tar -xvf /tmp/polygon-edge/polygon-edge.tar.gz -C /tmp/polygon-edge
sudo mv /tmp/polygon-edge/polygon-edge /usr/local/bin/
rm -R /tmp/polygon-edge

## Polygon Edge controller - it gets info from nodes when they are initialized and generates genesis.json
sudo snap install go --classic --channel=1.17
git clone https://github.com/Trapesys/polygon-edge-assm /tmp/edge-assm
cd /tmp/edge-assm && sudo go build -o artifacts/edge-assm . && sudo mv artifacts/edge-assm /usr/local/bin/ && cd -
edge-assm -chain-name "${chain_name}" -chain-id "${chain_id}" -block-gas-limit "${block_gas_limit}" -premine "${premine}" -epoch-size "${epoch_size}" &