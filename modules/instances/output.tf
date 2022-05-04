output "instance_dns_name" {
  value = aws_instance.polygon_edge_instance.private_dns
  description = "Private dns name of the instance"
}

output "bastion_eip" {
  description = "Bastion instance public ip address"
  value = aws_instance.polygon_edge_instance.public_ip
}

output "instance_ids" {
  value = aws_instance.polygon_edge_instance.id
  description = "Instance id"
}