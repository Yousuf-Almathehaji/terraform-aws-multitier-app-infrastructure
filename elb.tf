resource "aws_lb_target_group" "webtarget" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app-vpc.id
  health_check {
    path = "/"
    
  }
  tags = {
    Name = "web-target-group"
  }
  
}

resource "aws_lb" "web-distro" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albSG.id]
  subnets            = local.pubnet-ids

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web-distro.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.webtarget.arn
  }
}