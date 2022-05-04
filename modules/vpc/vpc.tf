// create new VPC
resource "aws_vpc" "polygon_edge_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name_tag
  }
}

// create new private subnet
resource "aws_subnet" "polygon_edge_lan" {
  count = length(var.az)
  vpc_id = aws_vpc.polygon_edge_vpc.id
  cidr_block = var.lan_subnets[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.lan_subnets_name_tag
  }
}

// create new public subnet
resource "aws_subnet" "polygon_edge_public" {
  count = length(var.az)
  vpc_id = aws_vpc.polygon_edge_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.public_subnets_name_tag
  }
}

// create new internet gateway for this VPC
resource "aws_internet_gateway" "polygon_edge_igw" {
  vpc_id = aws_vpc.polygon_edge_vpc.id
}

// assign new elastic ip to this internet gateway
resource "aws_eip" "polygon_edge_gw_eip" {
  vpc = true
}

// create new nat gateway 
resource "aws_nat_gateway" "polygon_edge_nat_gw" {
  allocation_id = aws_eip.polygon_edge_gw_eip.id
  subnet_id = aws_subnet.polygon_edge_public[0].id
  
  depends_on = [aws_internet_gateway.polygon_edge_igw]

  tags = {
    Name = var.nat_gateway_name_tag
  }
}

// associate default route to the internet gateway
resource "aws_route_table" "vpc_default" {
  vpc_id = aws_vpc.polygon_edge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.polygon_edge_igw.id
  }

  tags = {
    Name = var.default_route_name_tag
  }
}

// associate all public scopes with public (default) routing table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.polygon_edge_public)
  subnet_id = aws_subnet.polygon_edge_public[count.index].id
  route_table_id = aws_route_table.vpc_default.id
}

// set default route for the VPC
resource "aws_route" "default" {
  route_table_id = aws_vpc.polygon_edge_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id =  aws_nat_gateway.polygon_edge_nat_gw.id

  depends_on = [aws_nat_gateway.polygon_edge_nat_gw]
}

