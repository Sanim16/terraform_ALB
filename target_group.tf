resource "aws_lb_target_group" "target_grp_1" {
  name     = "tf-lb-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    path = "/"
    matcher = "200"
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400 #1 day
  }
}

resource "aws_lb_target_group" "target_grp_2" {
  name     = "tf-lb-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    path = "/"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "target_grp_default" {
  name     = "tf-lb-tg-default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    path = "/"
    matcher = "200"
  }
}
