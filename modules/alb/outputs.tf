output "dns_name" {
  value       = aws_lb.polygon_nodes.dns_name
  description = "The dns name for the JSON-RPC"
}