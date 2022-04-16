data "template_file" "bastion_node" {
  template = "${file("${path.module}/scripts/bastion.tpl")}"

  vars = {
    "bastion_private_key" = "${var.bastion_private_key}"
  }
}

data "template_file" "polygon_edge_node" {
  template = "${file("${path.module}/scripts/polygon_edge_node.tpl")}"

  vars = {
    "polygon_edge_dir" = var.polygon_edge_dir
    # defined in instance module 
    "ebs_device" = var.ebs_device
    "node_name" = var.node_name
    "assm_path" = var.assm_path
    "assm_region" = var.assm_region
    "controller_ip" = var.controller_ip
    "total_nodes" = var.total_nodes
  }
}



data "template_cloudinit_config" "bastion" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.bastion_node.rendered}"
  }
}

data "template_cloudinit_config" "polygon_edge" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.polygon_edge_node.rendered}"
  }
}
