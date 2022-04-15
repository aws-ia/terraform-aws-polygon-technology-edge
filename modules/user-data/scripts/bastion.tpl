#!/bin/bash

## Create private key that we use to login to Polygon-SDK instances
cat > /home/ubuntu/.ssh/id_ecdsa << EOF
${bastion_private_key}
EOF