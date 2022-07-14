#output "bastion" {
#  value = data.template_cloudinit_config.bastion.rendered
#  description = "Base64 rendered bastion user-init data"
#}

output "polygon_edge_node" {
  value       = data.template_cloudinit_config.polygon_edge.rendered
  description = "Base64 rendered polygon edge node user-init data"
}