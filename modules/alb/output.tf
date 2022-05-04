output "dns_name" {
  value = aws_lb.polygon-nodes.dns_name
  description = "The dns name for the JSON-RPC"
}