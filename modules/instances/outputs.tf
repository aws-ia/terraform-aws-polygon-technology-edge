output "instance_dns_name" {
  value       = aws_instance.polygon_edge_instance.private_dns
  description = "Private DNS name of the instance"
}

output "instance_id" {
  value       = aws_instance.polygon_edge_instance.id
  description = "ID of the instance"
}