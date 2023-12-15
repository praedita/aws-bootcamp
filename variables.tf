variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "instance_type" {
  default = "t3.micro"
}

# Network Mask - 255.255.255.0 Addresses Available - 256
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "publ_cidr_1" {
  default = "10.0.1.0/24" # 256 IPs
}
variable "priv_cidr_1" {
  default = "10.0.2.0/24" # 256 IPs
}
variable "publ_cidr_2" {
  default = "10.0.3.0/24" # 256 IPs
}
variable "priv_cidr_2" {
  default = "10.0.4.0/24" # 256 IPs
}
variable "cidr_blocks" {
  default = "0.0.0.0/0"
}
