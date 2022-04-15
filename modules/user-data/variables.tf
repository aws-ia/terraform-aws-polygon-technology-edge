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
  default = "/dev/xvdf"
  type = string
  description = "The ebs device path. Defined when creating EBS volume. Default: /dev/xvdf"
}

variable "assm_region" {
  default = "eu-central-1"
  type = string
  description = "The region for AWS SSM service. Default: eu-central-1"
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
