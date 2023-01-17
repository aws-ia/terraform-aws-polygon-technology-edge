variable "instance_type" {
  type        = string
  description = "Polygon Edge nodes instance type. Default: t3.medium"
}
variable "user_data_base64" {
  type        = string
  description = "The base64 encoded data of user data ( cloud-init script )"
}
variable "user_data_nv" {
  type        = string
  description = "The non-validator encoded data of user data ( cloud-init script )"
}
variable "az" {
  type        = string
  description = "The availability zone of the instance."
}
variable "ebs_root_name_tag" {
  type        = string
  description = "The name tag for the Polygon Edge instance root volume."
}

variable "instance_name" {
  type        = string
  description = "The name of Polygon Edge instance"
}

variable "internal_subnet" {
  description = "The subnet id in which to place the instance."
  type        = string
}

variable "internal_sec_groups" {
  type        = list(string)
  description = "The list of security groups to attach to the instance."
}

variable "instance_interface_name_tag" {
  type        = string
  description = "The name of the instance interface. Default: Polygon_Edge_Instance_Interface"
}

variable "chain_data_ebs_volume_size" {
  type        = number
  description = "The size of the chain data EBS volume. Default: 30"
}

variable "chain_data_ebs_name_tag" {
  type        = string
  description = "The name of the chain data EBS volume. Default: Polygon_Edge_chain_data_ebs_volume"
}


variable "instance_iam_role" {
  type        = string
  description = "The IAM role to attach to the instance"
}