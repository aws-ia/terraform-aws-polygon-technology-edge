variable "nodes_alb_name" {
  type = string
  description = "ALB name"
  default = "polygon-edge-jsonrpc"
}

variable "nodes_alb_name_tag" {
  type = string
  description = "ALB name tag"
  default = "Polygon Edge JSON-RPC ALB"
}

variable "public_subnets" {
  type = list(any)
  description = "The list of public subnets"
}

variable "alb_sec_group" {
  type = string
  description = "The security group to place the ALB in"
}

variable "nodes_nlb_targetgroup_name" {
  type = string
  description = "ALB target group name"
  default = "polygon-edge-jsonrpc-targetgroup"
}

variable "nodes_nlb_targetgroup_port" {
  type = number
  description = "The port for json-rpc api exposed on the nodes"
  default = 8545
}

variable "nodes_nlb_targetgroup_proto" {
  type = string
  description = "The protocol for json-rpc API"
  default = "HTTP"
}

variable "vpc_id" {
  type = string
  description = "VPC id"
}

variable "nodes_nlb_listener_port" {
  type = number
  description = "The port on whitch ALB will listen on"
  default = 80
}

variable "node_ids" {
  type = list(string)
  description = "The ids of the nodes to place in targetgroup"
}