# # Select the newest AMI

# data "aws_ami" "latest-launch-ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023*x86_64"]
#   }
# }


# Create a launch template for the EC2 instance

resource "aws_launch_template" "capstone-dev-launch-template" {
  name = "capstoneAMILaunchTemplate"
  # image_id               = data.aws_ami.latest-launch-ami.id
  image_id               = "ami-0759f51a90924c166"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.capstone-dev-web-instance-sg.id]
  key_name               = "admin_us_east_1"
  user_data              = filebase64("user_data.sh")


  # Attach an IAM profile to the EC2 instance

  iam_instance_profile {
    name = "deham9_ec2"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "capstoneEC2InstanceAS"
    }
  }
}

# Create an autoscaling group

resource "aws_autoscaling_group" "capstone-dev-autoscaling-group" {
  name             = "capstoneASGroup"
  max_size         = 4
  min_size         = 2
  desired_capacity = 2

  vpc_zone_identifier       = [aws_subnet.capstone-dev-web-public-1a-1.id, aws_subnet.capstone-dev-web-public-1b-1.id]
  target_group_arns         = [aws_lb_target_group.capstone-dev-lb-target-group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.capstone-dev-launch-template.id
    version = "$Latest"
  }
}

# Create an autoscaling policy

resource "aws_autoscaling_policy" "capstone-dev-autoscaling-policy" {
  name        = "capstoneAsCPUPolicy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
  autoscaling_group_name = aws_autoscaling_group.capstone-dev-autoscaling-group.name
}