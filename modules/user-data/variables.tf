variable "bastion_private_key" {
  default = ""
  type = string
  description = "The private key for bastion user to authenticate to Polygon Nodes."
}

variable "polygon_edge_dir" {
  default = "/home/ubuntu/polygon"
  type = string
  description = "The directory to place all polygon-edge data and logs Default: /home/ubuntu/polygon"
}

variable "ebs_device" {
  default = "/dev/nvme1n1"
  type = string
  description = "The ebs device path. Defined when creating EBS volume. Default: /dev/nvme1n1"
}

variable "assm_region" {
  default = "us-west-2"
  type = string
  description = "The region for AWS SSM service. Default: us-west-2"
}

variable "assm_path" {
  default = "/polygon-edge/nodes"
  type = string
  description = "The SSM paramter path. Default: /polygon-edge/nodes"
}

variable "node_name" {
  type = string
  description = "The name of the node that will be different for every node and stored in AWS SSM"
}

variable "controller_dns" {
  type = string
  description = "The dns name of the node which is running edge controller service"
}

variable "total_nodes" {
  type = string
  description = "The total number of validator nodes. Default: 4"
  default = "4"
}

variable "s3_bucket_name" {
  type = string
  description = "The name of the S3 bucket that holds genesis.json. Default: polygon-edge-shared"
  default = "polygon-edge-shared"
}

// genesis options
variable "chain_name" {
  type = string
  description = "Set the name of chain"
  default = ""
}

variable "chain_id" {
  type = string
  description = "Set the Chain ID"
  default = ""
}

variable "block_gas_limit" {
  type = string
  description = "Set the block gas limit"
  default = ""
}

variable "premine" {
  type = string
  description = "Premine the accounts with the specified ammount. Format: account:ammount,account:ammount"
}

variable "epoch_size" {
  type = string
  description = "Set the epoch size"
  default = ""
}
// server options
variable "prometheus_address" {
  type = string
  description = "Enable Prometheus API"
  default = ""
}
variable "block_gas_target" {
  type = string
  description = "Sets the target block gas limit for the chain"
  default = ""
}
variable "nat_address" {
  type = string
  description = "Sets the NAT address for the networking package"
  default = ""
}
variable "dns_name" {
  type = string
  description = "Sets the DNS name for the network package"
  default = ""
}
variable "price_limit" {
  type = string
  description = "Sets minimum gas price limit to enforce for acceptance into the pool"
  default = ""
}
variable "max_slots" {
  type = string
  description = "Sets maximum slots in the pool"
  default = ""
}
variable "block_time" {
  type = string
  description = "Set block production time in seconds"
  default = ""
}