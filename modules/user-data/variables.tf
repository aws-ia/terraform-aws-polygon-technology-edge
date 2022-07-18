variable "polygon_edge_dir" {
  type        = string
  description = "The directory to place all polygon-edge data and logs"
}
variable "ebs_device" {
  type        = string
  description = "The ebs device path. Defined when creating EBS volume."
}
variable "assm_region" {
  type        = string
  description = "The region for AWS SSM service."
}
variable "assm_path" {
  type        = string
  description = "The SSM paramter path."
}
variable "node_name" {
  type        = string
  description = "The name of the node that will be different for every node and stored in AWS SSM"
}
variable "total_nodes" {
  type        = string
  description = "The total number of validator nodes."
}
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket that holds genesis.json."
}

## genesis options
variable "chain_name" {
  type        = string
  description = "Set the name of chain"
}
variable "chain_id" {
  type        = string
  description = "Set the Chain ID"
}
variable "block_gas_limit" {
  type        = string
  description = "Set the block gas limit"
}
variable "premine" {
  type        = string
  description = "Premine the accounts with the specified ammount."
}
variable "epoch_size" {
  type        = string
  description = "Set the epoch size"
}
variable "pos" {
  type        = bool
  description = "Deploy with PoS consensus"
}
variable "max_validator_count" {
  type        = string
  description = "Maximum number of stakers able to join the validator set in a PoS consensus."
}
variable "min_validator_count" {
  type        = string
  description = "Minimum number of stakers needed to join the validator set in a PoS consensus."
}
variable "consensus" {
  type        = string
  description = "Sets the consensus protocol"
}

# server options
variable "prometheus_address" {
  type        = string
  description = "Enable Prometheus API"
}
variable "block_gas_target" {
  type        = string
  description = "Sets the target block gas limit for the chain"
}
variable "nat_address" {
  type        = string
  description = "Sets the NAT address for the networking package"
}
variable "dns_name" {
  type        = string
  description = "Sets the DNS name for the network package"
}
variable "price_limit" {
  type        = string
  description = "Sets minimum gas price limit to enforce for acceptance into the pool"
}
variable "max_slots" {
  type        = string
  description = "Sets maximum slots in the pool"
}
variable "block_time" {
  type        = string
  description = "Set block production time in seconds"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the chain init Lambda function"
}

variable "s3_key_name" {
  type        = string
  description = "Name for the config file stored in S3"
}