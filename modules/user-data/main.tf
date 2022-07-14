data "template_file" "polygon_edge_node" {
  template = file("${path.module}/scripts/polygon_edge_node.tpl")

  vars = {
    "polygon_edge_dir" = var.polygon_edge_dir
    "ebs_device"       = var.ebs_device
    "node_name"        = var.node_name
    "assm_path"        = var.assm_path
    "assm_region"      = var.assm_region
    "total_nodes"      = var.total_nodes
    "s3_bucket_name"   = var.s3_bucket_name
  }
}

data "template_file" "polygon_edge_server" {
  template = file("${path.module}/scripts/polygon_edge_server.tpl")
  vars = {
    "polygon_edge_dir"   = var.polygon_edge_dir
    "s3_bucket_name"     = var.s3_bucket_name
    "prometheus_address" = var.prometheus_address
    "block_gas_target"   = var.block_gas_target
    "nat_address"        = var.nat_address
    "dns_name"           = var.dns_name
    "price_limit"        = var.price_limit
    "max_slots"          = var.max_slots
    "block_time"         = var.block_time
  }
}

data "template_cloudinit_config" "polygon_edge" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.polygon_edge_node.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.polygon_edge_server.rendered
  }
}
