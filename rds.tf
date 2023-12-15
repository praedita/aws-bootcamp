# # Create a Subnet Group for the database

# resource "aws_db_subnet_group" "capstone-dev-db-private-1" {
#   name       = "capstone-dev-db-private-1"
#   subnet_ids = [aws_subnet.capstone-dev-db-private-1a-1.id, aws_subnet.capstone-dev-db-private-1b-1.id]

#   tags = {
#     Name = "capstoneDbSubnetGroup"
#   }
# }

# resource "aws_rds_cluster" "capstone-dev-aurora-cluster" {
#   cluster_identifier = "aurora-cluster"
#   availability_zones = ["us-west-2a", "us-west-2b"]

#   engine         = "aurora-mysql"
#   engine_version = "5.7.mysql_aurora.2.11.1"

#   lifecycle {
#     ignore_changes = [engine_version]
#   }

#   database_name   = "auroraDB"
#   master_username = "admin"
#   master_password = "verydifficultpassword"

#   skip_final_snapshot       = true
#   final_snapshot_identifier = "aurora-final-snapshot"

#   db_subnet_group_name = aws_db_subnet_group.capstone-dev-db-private-1.name

#   vpc_security_group_ids = [aws_security_group.capstone-dev-db-instance-sg.id]


#   tags = {
#     Name = "capstoneDbAuroraCluster"
#   }
# }

# resource "aws_rds_cluster_instance" "capstone-dev-aurora-instance" {
#   count               = 1
#   identifier          = "aurora-instance-${count.index + 1}"
#   cluster_identifier  = aws_rds_cluster.capstone-dev-aurora-cluster.id
#   instance_class      = "db.t3.small"
#   engine              = "aurora-mysql"
#   availability_zone   = "us-west-2${count.index == 0 ? "a" : "b"}"
#   publicly_accessible = true

#   tags = {
#     Name = "capstoneDbAuroraInstance${count.index + 1}"
#   }
# }

# resource "aws_security_group" "capstone-dev-db-instance-sg" {
#   name        = "capstoneDbInstanceSg"
#   description = "Allow EC2 access to Aurora"
#   vpc_id      = aws_vpc.capstone-dev-vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     # security_groups = [aws_security_group.allow_ssh.id] 
#   }

#   tags = {
#     Name = "capstoneSgDbInstance"
#   }
# }