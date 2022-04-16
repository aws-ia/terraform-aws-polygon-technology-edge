// create the instance
resource "aws_instance" "polygon_edge_instance" {
  ami = data.aws_ami.ubuntu20-04.id
  instance_type = var.instance_type
  key_name = var.ssh_key_name
  user_data_base64 = "${var.user_data_base64}"
  availability_zone = var.az
  iam_instance_profile = var.instance_iam_role

  root_block_device {
    tags = {
      Name = var.ebs_root_name_tag
    }
  }

  tags = {
    Name = var.instance_name
  }

  // attach the network interface
  network_interface {
    network_interface_id = aws_network_interface.instance_interface.id
    device_index = 0
  }
}

// create the instance network interface
resource "aws_network_interface" "instance_interface" {
  subnet_id = var.internal_subnet.id
  security_groups = var.internal_sec_groups
  // set static ip addresses for all nodes
  private_ips = [ join("", [trimsuffix("${var.internal_subnet.cidr_block}","0/24"), var.node_index+4]) ]

  tags = {
    Name = var.instance_interface_name_tag
  }
}

// create the EBS volume to hold the chain data
resource "aws_ebs_volume" "chain_data" {
  // create EBS volumes only if this is polygon edge instance
  count = var.polygon_edge_instance_type ? 1 : 0

  availability_zone = var.az
  size = var.chain_data_ebs_volume_size

  tags = {
    Name = var.chain_data_ebs_name_tag
  }
}

resource "aws_volume_attachment" "attach_chain_data" {
  // attach EBS volumes only if this is polygon edge instance
  count = var.polygon_edge_instance_type ? 1 : 0

  device_name = "/dev/sdf"
  volume_id = aws_ebs_volume.chain_data[count.index].id
  instance_id = aws_instance.polygon_edge_instance.id
  force_detach = true
}

resource "aws_eip" "bastion" {
  // do not create EIP if this is a Polygon Edge node
  count = var.polygon_edge_instance_type ? 0 : 1
  instance = aws_instance.polygon_edge_instance.id
  vpc = true
}
