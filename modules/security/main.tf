resource "aws_security_group" "polygon_internal" {
  name_prefix = "Polygon_Edge_Node_Internal_"
  description = "Allow Internal Traffic on Polygon Edge Nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.internal_sec_gr_name_tag
  }
}

resource "aws_security_group" "json_rpc_alb" {
  name_prefix = "Poligon_Edge_JSONRPC_ALB_"
  description = "Allow External Traffic to ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.alb_sec_gr_name_tag
  }
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_nodes_egress" {
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.polygon_internal.id
  type              = "egress"
}

resource "aws_security_group_rule" "allow_jsonrpc" {
  description              = "Allow Public Access to nodes JSON-RPC"
  from_port                = 8545
  to_port                  = 8545
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.json_rpc_alb.id
  security_group_id        = aws_security_group.polygon_internal.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_libp2p" {
  description       = "LibP2P Allow"
  from_port         = 1478
  to_port           = 1478
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.polygon_internal.id
  type              = "ingress"
}
#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "allow_alb_egress" {
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.json_rpc_alb.id
  type              = "egress"
}
#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_alb_http" {
  description       = "Allow HTTP traffic for ALB"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.json_rpc_alb.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_alb_https" {
  description       = "Allow HTTPS traffic for ALB"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.json_rpc_alb.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
