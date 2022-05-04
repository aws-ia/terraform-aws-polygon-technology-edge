variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "internal_sec_gr_name_tag" {
  default = "Polygon Edge Internal Sec Group"
  type = string
  description = "Internal security group name tag"
}

variable "bastion_sec_gr_name_tag" {
  type = string
  description = "Bastion security group name tag"
  default = "Polygon Edge Bastion Sec Group"
}

variable "ssh_key_name" {
  type = string
  description = "The name of the SSH public key"
}

variable "ssh_public_key" {
  type = string
  description = "The SSH public key value"
}

variable "admin_public_ip" {
  type = string
  description = "The admin public ip address that will be used to access the Bastion instance. Must be in CIDR format!"
} 

variable "region" {
  type = string
  description = "The region in which instances reside. Default: us-west-2"
  default = "us-west-2"
}

variable "account_id" {
  type = string
  description = "The AWS account ID"
}

variable "alb_sec_gr_name_tag" {
  type = string
  description = "The name tag for ALB security group"
  default = "Polygon Edge JSON-RPC ALB Sec Group"
}