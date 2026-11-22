data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "school_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "School-VPC"
    Environment = var.project_name
  }
}

resource "aws_internet_gateway" "school_igw" {
  vpc_id = aws_vpc.school_vpc.id

  tags = {
    Name = "School-IGW"
  }
}

resource "aws_subnet" "external" {
  vpc_id                  = aws_vpc.school_vpc.id
  cidr_block              = var.external_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "School-External-Subnet"
  }
}

resource "aws_subnet" "internal" {
  vpc_id                  = aws_vpc.school_vpc.id
  cidr_block              = var.internal_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "School-Internal-Subnet"
  }
}

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.school_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.school_igw.id
  }

  tags = {
    Name = "School-External-Route-Table"
  }
}

resource "aws_route_table_association" "external" {
  subnet_id      = aws_subnet.external.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table" "internal" {
  vpc_id = aws_vpc.school_vpc.id

  tags = {
    Name = "School-Internal-Route-Table"
  }
}

resource "aws_route_table_association" "internal" {
  subnet_id      = aws_subnet.internal.id
  route_table_id = aws_route_table.internal.id
}
