# Select the newest AMI

data "aws_ami" "latest-linux-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }
}

# Create an EC2 instance

resource "aws_instance" "capstone-dev-instance" {
  ami                         = data.aws_ami.latest-linux-ami.id
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available.names[0]
  associate_public_ip_address = true
  key_name                    = "admin_us_east_1"
  vpc_security_group_ids      = [aws_security_group.capstone-dev-web-instance-sg.id]
  subnet_id                   = aws_subnet.capstone-dev-web-public-1a-1.id
  iam_instance_profile        = "deham9_ec2"
  count                       = 1
  tags = {
    Name = "capstoneEC2Instance"
  }

  user_data = file("user_data.sh")

  provisioner "local-exec" {
    command = "echo Instance Type = ${self.instance_type}, Instance ID = ${self.id}, Public IP = ${self.public_ip}, AMI ID = ${self.ami} >> metadata"
  }
}

# Create a security group for the VPC
resource "aws_security_group" "capstone-dev-web-instance-sg" {
  name        = "capstoneSgInstance"
  description = "Allow traffic to the instance"
  vpc_id      = aws_vpc.capstone-dev-vpc.id

  # Add inbound rules
  # Add a rule for HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_blocks]
  }

  # Add a rule for HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_blocks]
  }

  # Add a rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_blocks]
  }

  # Add an outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks]
  }
  tags = {
    Name = "capstoneSgWebInstance"
  }
}