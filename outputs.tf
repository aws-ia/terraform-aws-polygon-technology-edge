output "jsonrpc_dns_name" {
  value       = module.alb.dns_name
  description = "The dns name for the JSON-RPC API"
}