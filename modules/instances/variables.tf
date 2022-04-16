variable "instance_type" {
  default = "t2.medium"
  type = string
  description = "Polygon Edge nodes instance type. Default: t2.medium"
}

variable "ssh_key_name" {
  type = string
  description = "The ssh key used to login to the instance."
}

variable "user_data_base64" {
  default = ""
  type = string
  description = "The base64 encoded data of user data ( cloud-init script )"
}

variable "az" {
  default = "eu-central-1a"
  type = string
  description = "The availability zone of the instance. Default: eu-central-1a"
}

variable "ebs_root_name_tag" {
  default = "Polygon_Edge_Root_EBS_Volume"
  type = string
  description = "The name tag for the Polygon Edge instance root volume. Default: Polygon_Edge_Root_EBS_Volume"
}

variable "instance_name" {
  default = "Polygon_Edge_Instance"
  type = string
  description = "The name of Polygon Edge instance"
}

variable "internal_subnet" {
  description = "The subnet id in which to place the instance."
}

variable "internal_sec_groups" {
  type = list(string)
  description = "The list of security groups to attach to the instance."
}

variable "instance_interface_name_tag" {
  default = "Polygon_Edge_Instance_Interface"
  type = string
  description = "The name of the instance interface. Default: Polygon_Edge_Instance_Interface"
}

variable "chain_data_ebs_volume_size" {
  default = 30
  type = number
  description = "The size of the chain data EBS volume. Default: 30"
}

variable "chain_data_ebs_name_tag" {
  default = "Polygon_Edge_chain_data_ebs_volume"
  type = string
  description = "The name of the chain data EBS volume. Default: Polygon_Edge_chain_data_ebs_volume"
}

variable "polygon_edge_instance_type" {
  default = true
  type = bool
  description = "Is this instance used to run Polygon Edge chain?"
}

variable "instance_iam_role" {
  default = ""
  type = string
  description = "The IAM role to attach to the instance"
}

variable "node_index" {
  default = 0
  type = number
  description = "The count.index of the node"
}