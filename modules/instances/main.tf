# create the instance
resource "aws_instance" "polygon_edge_instance" {
  ami                  = data.aws_ami.ubuntu_20_04.id
  instance_type        = var.instance_type
  user_data_base64     = var.user_data_base64
  availability_zone    = var.az
  iam_instance_profile = var.instance_iam_role

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
    tags = {
      Name = var.ebs_root_name_tag
    }
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = var.instance_name
  }

  # attach the network interface
  network_interface {
    network_interface_id = aws_network_interface.instance_interface.id
    device_index         = 0
  }
}

#Create the non-validator instance
resource "aws_instance_nv" "polygon_edge_instance_nv" {
  ami                  = data.aws_ami.ubuntu_20_04.id
  instance_type        = var.instance_type
  user_data_nv     	   = var.user_data_nv
  availability_zone    = us-east-1d
  iam_instance_profile = var.instance_iam_role

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
    tags = {
      Name = var.ebs_root_name_tag
    }
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = var.instance_name
  }

  # attach the network interface
  network_interface {
    network_interface_id = aws_network_interface.instance_interface.id
    device_index         = 0
  }
}


# create the instance network interface
resource "aws_network_interface" "instance_interface" {
  subnet_id       = var.internal_subnet
  security_groups = var.internal_sec_groups

  tags = {
    Name = var.instance_interface_name_tag
  }
}

# create the EBS volume to hold the chain data
#tfsec:ignore:aws-ebs-encryption-customer-key
resource "aws_ebs_volume" "chain_data" {

  availability_zone = us-east-1d
  size              = var.chain_data_ebs_volume_size
  encrypted         = true

  tags = {
    Name = var.chain_data_ebs_name_tag
  }
}

resource "aws_volume_attachment" "attach_chain_data" {

  device_name  = "/dev/sdf"
  volume_id    = aws_ebs_volume.chain_data.id
  instance_id  = aws_instance.polygon_edge_instance.id
  force_detach = true
}
