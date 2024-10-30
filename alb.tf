resource "aws_lb" "main" {
  name                       = "main-lb-tf"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = module.vpc.public_subnets
  ip_address_type            = "ipv4"
  drop_invalid_header_fields = true
  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.s3_lb_logs_bucket.id
    prefix  = "main-lb-tf"
    enabled = true
  }

  tags = {
    Environment = "dev"
    Name        = "terraform-${var.vpc_name}-alb"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn

  port            = "80"
  protocol        = "HTTP"
  # ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
  # certificate_arn = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_grp_default.arn
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
      values = ["/path1*"]
    }
  }

  depends_on = [aws_lb_listener.main]
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
      values = ["/path2*"]
    }
  }

  depends_on = [aws_lb_listener.main]
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
