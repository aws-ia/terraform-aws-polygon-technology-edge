output "polygon_edge_node" {
  value       = data.cloudinit_config.polygon_edge.rendered
  description = "Base64 rendered polygon edge node user-init data"
}