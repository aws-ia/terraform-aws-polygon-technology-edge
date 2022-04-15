variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "internal_sec_gr_name_tag" {
  default = "Polygon_Edge_Internal"
  type = string
  description = "Internal security group name tag"
}