output "vpc_id" {
  value = aws_vpc.polygon_edge_vpc.id
  description = "VPC id"
}

output "internal_subnets" {
  value = aws_subnet.polygon_edge_lan
  description = "Internal networks object"
}

output "external_subnets" {
  value = aws_subnet.polygon_edge_public
  description = "External networks object"
}

output "av_zones" {
  value = var.az
  description = "The list of VPC availability zones"
}