output "jsonrpc_dns_name" {
  value = module.alb.dns_name
  description = "The dns name for the JSON-RPC API"
}

output "bastion_instance_public_ip" {
  value = module.bastion_instance.bastion_eip
  description = "The public ip address of the bastion instance"
}