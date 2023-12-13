# Create a VPC

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc"
  }

  provisioner "local-exec" {
    command = "echo VPC ID = ${self.id} >> metadata"
  }

}