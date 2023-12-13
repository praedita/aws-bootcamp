# Create a VPC

data "aws_availability_zones" "available" {}

resource "aws_vpc" "capstone-dev-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "capstoneVPC"
  }

  provisioner "local-exec" {
    command = "echo VPC ID = ${self.id} >> metadata"
  }

}

# Create Public Subnet 1
resource "aws_subnet" "capstone-dev-web-public-1a-1" {
  vpc_id                  = aws_vpc.capstone-dev-vpc.id
  cidr_block              = var.publ_cidr_1
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "capstonePublicSubnet1a"
  }

  provisioner "local-exec" {
    command = "echo public subnet 1a = ${self.id} >> metadata"
  }
}

# Create Private Subnet 1
resource "aws_subnet" "capstone-dev-db-private-1a-1" {
  vpc_id                  = aws_vpc.capstone-dev-vpc.id
  cidr_block              = var.priv_cidr_1
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "capstonePrivateSubnet1a"
  }
  provisioner "local-exec" {
    command = "echo private subnet 1a = ${self.id} >> metadata"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "capstone-dev-web-public-1b-1" {
  vpc_id                  = aws_vpc.capstone-dev-vpc.id
  cidr_block              = var.publ_cidr_2
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "capstonePublicSubnet1b"
  }

  provisioner "local-exec" {
    command = "echo public subnet 1b = ${self.id} >> metadata"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "capstone-dev-db-private-1b-1" {
  vpc_id                  = aws_vpc.capstone-dev-vpc.id
  cidr_block              = var.priv_cidr_2
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "capstonePrivateSubnet1b"
  }
  provisioner "local-exec" {
    command = "echo private subnet 1b = ${self.id} >> metadata"
  }

}

# Create an Internet Gateway
resource "aws_internet_gateway" "capstone-dev-igw" {
  vpc_id = aws_vpc.capstone-dev-vpc.id
  tags = {
    Name = "capstoneIGW"
  }
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "capstone-dev-eip" {
  vpc = true
}

# Create a NAT Gateway for the private subnet(s) to access the internet
resource "aws_nat_gateway" "capstone-dev-nat-gw" {
  allocation_id = aws_eip.capstone-dev-eip.id
  subnet_id     = aws_subnet.capstone-dev-web-public-1a-1.id # Reference public subnet ID

  tags = {
    Name = "capstoneNatGW"
  }
}

resource "aws_route_table" "capstone-dev-public-rt" {
  vpc_id = aws_vpc.capstone-dev-vpc.id

  route {
    cidr_block = var.cidr_blocks
    gateway_id = aws_internet_gateway.capstone-dev-igw.id
  }
  tags = {
    Name = "capstonePublicRouteTable"
  }
}

resource "aws_route_table" "capstone-dev-private-rt" {
  vpc_id = aws_vpc.capstone-dev-vpc.id

  route {
    cidr_block = var.cidr_blocks
    gateway_id = aws_nat_gateway.capstone-dev-nat-gw.id
  }
  tags = {
    Name = "capstonePrivateRouteTable"
  }
}
resource "aws_route_table_association" "capstone-public-1a-rt-association" {
  route_table_id = aws_route_table.capstone-dev-public-rt.id
  subnet_id      = aws_subnet.capstone-dev-web-public-1a-1.id
  depends_on     = [aws_route_table.capstone-dev-public-rt, aws_subnet.capstone-dev-web-public-1a-1]
}

resource "aws_route_table_association" "capstone-private-1a-rt-association" {
  route_table_id = aws_route_table.capstone-dev-private-rt.id
  subnet_id      = aws_subnet.capstone-dev-db-private-1a-1.id
  depends_on     = [aws_route_table.capstone-dev-private-rt, aws_subnet.capstone-dev-db-private-1a-1]
}

resource "aws_route_table_association" "capstone-public-1b-rt-association" {
  route_table_id = aws_route_table.capstone-dev-public-rt.id
  subnet_id      = aws_subnet.capstone-dev-web-public-1b-1.id
  depends_on     = [aws_route_table.capstone-dev-public-rt, aws_subnet.capstone-dev-web-public-1b-1]
}

resource "aws_route_table_association" "capstone-private-1b-rt-association" {
  route_table_id = aws_route_table.capstone-dev-private-rt.id
  subnet_id      = aws_subnet.capstone-dev-db-private-1b-1.id
  depends_on     = [aws_route_table.capstone-dev-private-rt, aws_subnet.capstone-dev-db-private-1b-1]
}