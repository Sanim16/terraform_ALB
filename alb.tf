resource "aws_lb" "main" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
  # subnets            = [for subnet in aws_subnet.public : subnet.id]
  ip_address_type = "ipv4"

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "dev"
    Name        = "terraform-${var.vpc_name}-alb"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_grp_1.arn
  }
}

resource "aws_lb_listener_rule" "main_1" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_grp_1.arn
  }

  condition {
    path_pattern {
      values = ["/tg1"]
    }
  }
}

# Forward action

resource "aws_lb_listener_rule" "main_2" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_grp_2.arn
  }

  condition {
    path_pattern {
      values = ["/tg2"]
    }
  }
}

# Fixed-response action

resource "aws_lb_listener_rule" "error" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is an error"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = ["/error"]
    }
    # query_string {
    #   key   = "health"
    #   value = "check"
    # }

    # query_string {
    #   value = "bar"
    # }
  }
}



















resource "aws_security_group" "alb" {
  name        = "terraform-${var.vpc_name}-alb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-${var.vpc_name}-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb-http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb-https" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
