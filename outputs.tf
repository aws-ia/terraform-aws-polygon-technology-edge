output "jsonrpc_dns_name" {
  value       = module.alb.dns_name
  description = "The DNS name for the JSON-RPC API"
}