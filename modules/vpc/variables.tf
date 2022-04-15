variable "vpc_cidr_block" {
  default = "10.250.0.0/16"
  type = string
  description = "The CIDR subnet for this VPC. Default: 10.250.0.0/16"
}

variable "vpc_name_tag" {
  default = "Polygon_Edge_VPC"
  type = string
  description = "The name tag for this VPC. Default: Polygon_Edge_VPC"
}

variable "az" {
  default = ["eu-central-1a","eu-central-1b","eu-central-1c"]
  type = list(string)
  description = "The availability zones in this VPC. Default: eu-central-1a/b/c"
}

variable "lan_subnets" {
  default = ["10.250.1.0/24","10.250.2.0/24","10.250.3.0/24"]
  type = list(string)
  description = "The internal/private networks. Defaults: 10.250.(1,2,3).0/24"
}

variable "lan_subnets_name_tag" {
  default = "Polygon_Edge_Internal_Subnet"
  type = string
  description = "The name tag for internal networks. Default: Polygon_Edge_Ineternal_Subnet"
}

variable "public_subnets" {
  default = ["10.250.251.0/24","10.250.252.0/24","10.250.253.0/24"]
  type = list(string)
  description = "The public network subnets. Defaults: 10.250.(251,252,253).0/24"
}

variable "public_subnets_name_tag" {
  default = "Polygon_Edge_Public_Subnet"
  type = string
  description = "The name tag for public network subnets. Default: Polygon_Edge_Public_Subnet"
}

variable "nat_gateway_name_tag" {
  default = "Polygon_Edge_NAT_Gateway"
  type = string
  description = "The name tag for NAT gateway. Deafult: Polygon_Edge_NAT_Gateway"
}

variable "default_route_name_tag" {
  default = "Polygon_Edge_Default_Route"
  type = string
  description = "The name tag for the default route. Default: Polygon_Edge_Default_Route"
}