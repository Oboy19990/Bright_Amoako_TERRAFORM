# create application load balancer


resource "aws_alb" "main" {
  name                       = "project"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.my-sgp.id]
  subnets                    = [aws_subnet.my_publicsubnet.id,aws_subnet.private.id]
  
  enable_deletion_protection = false



  tags = {
    Name = "project"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "project"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
