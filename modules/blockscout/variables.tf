variable "docker_compose_values" {
  type = object({
    postgres_password             = string
    postgres_user                 = string
    postgres_host                 = string
    blockscout_docker_image       = string
    rpc_address                   = string
    chain_id                      = string
    rust_verification_service_url = string
  })
  default = {
    blockscout_docker_image       = "blockscout/blockscout-polygon-supernets:4.1.8-prerelease-651fbf3e"
    postgres_host                 = "postgres"
    postgres_password             = "postgres"
    postgres_user                 = "postgres"
    rpc_address                   = "http://localhost:9632"
    chain_id                      = "93201"
    rust_verification_service_url = "https://sc-verifier.aws-k8s.blockscout.com/"
  }
  description = "Values for docker-compose generation"
}

variable "path_docker_compose_files" {
  type        = string
  default     = "/opt/blockscout"
  description = "Path for blockscout files"
}

variable "user" {
  description = "What user to service run as"
  type        = string
  default     = "root"
}

variable "ec2_instance_name" {
  type        = string
  default     = "blockscout-instance"
  description = "Name of ec2 instance"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Type of aws ec2 instance"
}

variable "image_name" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  description = "OS Image"
}

variable "vpc_sgs" {
  type        = any
  default     = []
  description = "Extended sgs to attach ec2 instance"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id where will create ec2 instance"
}

variable "tags" {
  type        = any
  default     = {}
  description = "Tags"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC id where will create required resources"
}

#Polygon server
variable "polygon_edge_dir" {
  type        = string
  description = "The directory to place all polygon-edge data and logs"
}
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket that holds genesis.json."
}
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
