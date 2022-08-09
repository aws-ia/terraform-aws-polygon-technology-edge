variable "nodes_alb_name_prefix" {
  type        = string
  description = "ALB name"
}
variable "nodes_alb_name_tag" {
  type        = string
  description = "ALB name tag"
}
variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnet IDs"
}
variable "alb_sec_group" {
  type        = string
  description = "The security group to place the ALB in"
}
variable "nodes_alb_targetgroup_name_prefix" {
  type        = string
  description = "ALB target group name"
}
variable "vpc_id" {
  type        = string
  description = "VPC id"
}
variable "node_ids" {
  type        = list(string)
  description = "The ids of the nodes to place in targetgroup"
}
variable "alb_ssl_certificate" {
  type        = string
  description = "The SSL certificate ARN for JSON-RPC load balancer"
}