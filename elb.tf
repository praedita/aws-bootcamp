# Create a target group for the load balancer

resource "aws_lb_target_group" "capstone-dev-lb-target-group" {
  name        = "capstoneELBTargetGroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.capstone-dev-vpc.id

  tags = {
    name = "capstoneELBTargetGgroup"
  }

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create an application load balancer for the target group

resource "aws_lb" "capstone-dev-alb" {
  name               = "capstoneELB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.capstone-dev-web-public-1a-1.id, aws_subnet.capstone-dev-web-public-1b-1.id]
  security_groups    = [aws_security_group.capstone-dev-web-instance-sg.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "capstoneALB"
  }
}

# Create a listener for the load balancer

resource "aws_lb_listener" "capstone-dev-alb-listener" {
  load_balancer_arn = aws_lb.capstone-dev-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone-dev-lb-target-group.arn
  }
}

# Attach the target group to the instances

resource "aws_lb_target_group_attachment" "capstone-dev-alb-attachment" {
  count            = length(aws_instance.capstone-dev-instance)
  target_group_arn = aws_lb_target_group.capstone-dev-lb-target-group.arn
  target_id        = aws_instance.capstone-dev-instance[count.index].id
}