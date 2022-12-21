# VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "polygon-edge-vpc"
}
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.250.0.0/16"
}

# S3
variable "s3_bucket_prefix" {
  description = "Name prefix for new S3 bucket"
  type        = string
  default     = "polygon-edge-shared-"
}
variable "s3_force_destroy" {
  type        = bool
  default     = true
  description = "Delete S3 bucket on destroy, even if the bucket is not empty"
}
variable "s3_key_name" {
  type        = string
  description = "Name of the file in S3 that will hold configuration"
  default     = "chain-config"
}

# SECURITY
variable "ssm_parameter_id" {
  description = "The id that will be used for storing and fetching from SSM Parameter Store"
  type        = string
  default     = "polygon-edge-validators"
}
variable "internal_sec_gr_name_tag" {
  type        = string
  description = "Internal security group name tag"
  default     = "Polygon Edge Internal"
}
variable "alb_sec_gr_name_tag" {
  type        = string
  description = "External security group name tag"
  default     = "Polygon Edge External"
}

# EC2
variable "instance_type" {
  default     = "t3.medium"
  type        = string
  description = "Polygon Edge nodes instance type."
}
variable "ebs_root_name_tag" {
  default     = "Polygon_Edge_Root_Volume"
  type        = string
  description = "The name tag for the Polygon Edge instance root volume."
}
variable "instance_name" {
  default     = "Polygon_Edge_Node"
  type        = string
  description = "The name of Polygon Edge instance"
}
variable "instance_interface_name_tag" {
  default     = "Polygon_Edge_Instance_Interface"
  type        = string
  description = "The name of the instance interface."
}
variable "chain_data_ebs_volume_size" {
  default     = 30
  type        = number
  description = "The size of the chain data EBS volume."
}
variable "chain_data_ebs_name_tag" {
  default     = "Polygon_Edge_chain_data_volume"
  type        = string
  description = "The name of the chain data EBS volume."
}

#CHAIN
variable "polygon_edge_dir" {
  default     = "/home/ubuntu/polygon"
  type        = string
  description = "The directory to place all polygon-edge data and logs"
}

variable "ebs_device" {
  default     = "/dev/nvme1n1"
  type        = string
  description = "The ebs device path. Defined when creating EBS volume."
}

variable "node_name_prefix" {
  type        = string
  description = "The name prefix that will be used to store secrets"
  default     = "node"
}

## GENESIS
variable "chain_name" {
  type        = string
  description = "Set the name of chain"
  default     = ""
}

variable "chain_id" {
  type        = string
  description = "Set the Chain ID"
  default     = ""
}

variable "block_gas_limit" {
  type        = string
  description = "Set the block gas limit"
  default     = ""
}

variable "premine" {
  type        = string
  description = "Premine the accounts with the specified ammount. Format: account:ammount,account:ammount"
}

variable "epoch_size" {
  type        = string
  description = "Set the epoch size"
  default     = ""
}
variable "consensus" {
  type        = string
  description = "Sets consensus protocol."
  default     = ""
}
variable "max_validator_count" {
  type        = string
  description = "The maximum number of stakers able to join the validator set in a PoS consensus."
  default     = ""
}
variable "min_validator_count" {
  type        = string
  description = "The minimum number of stakers needed to join the validator set in a PoS consensus."
  default     = ""
}
variable "pos" {
  type        = bool
  description = "Use PoS IBFT consensus"
  default     = false
}
# server options
variable "prometheus_address" {
  type        = string
  description = "Enable Prometheus API"
  default     = ""
}
variable "block_gas_target" {
  type        = string
  description = "Sets the target block gas limit for the chain"
  default     = ""
}
variable "nat_address" {
  type        = string
  description = "Sets the NAT address for the networking package"
  default     = ""
}
variable "dns_name" {
  type        = string
  description = "Sets the DNS name for the network package"
  default     = ""
}
variable "price_limit" {
  type        = string
  description = "Sets minimum gas price limit to enforce for acceptance into the pool"
  default     = ""
}
variable "max_slots" {
  type        = string
  description = "Sets maximum slots in the pool"
  default     = ""
}
variable "block_time" {
  type        = string
  description = "Set block production time in seconds"
  default     = ""
}

#ALB
variable "alb_ssl_certificate" {
  type        = string
  description = "SSL certificate ARN for JSON-RPC loadblancer"
}
variable "nodes_alb_name_prefix" {
  type        = string
  description = "ALB name"
  default     = "jrpc-"
}
variable "nodes_alb_name_tag" {
  type        = string
  description = "ALB name tag"
  default     = "Polygon Edge JSON-RPC ALB"
}
variable "nodes_alb_targetgroup_name_prefix" {
  type        = string
  description = "ALB target group name"
  default     = "jrpc-"
}
# LAMBDA
variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function used for chain init"
  default     = "polygon-edge-init"
}
variable "lambda_function_zip" {
  type        = string
  description = "The lambda function code in zip archive"
  default     = "https://raw.githubusercontent.com/Trapesys/polygon-edge-assm/aws-lambda/artifacts/main.zip"
}

#blockscout
variable "blockscout_alb_ssl_certificate" {
  type        = string
  description = "SSL certificate ARN for JSON-RPC Blockscout loadblancer"
}
variable "blockscout_nodes_alb_name_prefix" {
  type        = string
  description = "ALB name"
  default     = "blck-"
}
variable "blockscout_nodes_alb_name_tag" {
  type        = string
  description = "ALB name tag"
  default     = "Blockscout JSON-RPC ALB"
}
variable "blockscout_nodes_alb_targetgroup_name_prefix" {
  type        = string
  description = "ALB target group name"
  default     = "blck-"
}