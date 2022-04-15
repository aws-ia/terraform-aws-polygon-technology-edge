resource "aws_security_group" "polygon_internal" {
  name        = "Poligon_Edge_allow_internal"
  description = "Allow Internal Traffic"
  vpc_id      = var.vpc_id


  ingress = [
    // allow internal libp2p communication
    {
      description      = "LibP2P Allow"
      from_port        = 1478
      to_port          = 1478
      protocol         = "tcp"
      self          = true
      cidr_blocks = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    },
    // allow public access to the JSON-RPC API
    {
      description      = "Allow Public Access to nodes JSON-RPC"
      from_port        = 8545
      to_port          = 8545
      protocol         = "tcp"
      self          = false
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    },
    // allow ssh access from Bastion instance
    {
      description      = "Allow SSH access from Bastion instance"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      self          = false
      cidr_blocks = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.bastion_public.id]
    },
  ]

  // egress not limited
  egress = [
    {
        description = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = true

    }
  ]

  tags = {
    Name = var.internal_sec_gr_name_tag
  }
}

resource "aws_security_group" "bastion_public" {
  name        = "Bastion_Public"
  description = "Allow Bastion Public Traffic"
  vpc_id      = var.vpc_id


  ingress = [
    // allow internal libp2p communication
    {
      description      = "SSH Allow"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      self          = false
      cidr_blocks = ["87.116.190.58/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    },
  ]

  // egress not limited
  egress = [
    {
        description = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = true

    }
  ]

  tags = {
    Name = var.internal_sec_gr_name_tag
  }
}