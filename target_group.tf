resource "aws_lb_target_group" "target_grp_1" {
  name     = "tf-lb-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "target_grp_1" {
  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
  for_each = {
    for k, v in aws_instance.target_grp_1 :
    k => v
  }
  target_group_arn = aws_lb_target_group.target_grp_1.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_target_group" "target_grp_2" {
  name     = "tf-lb-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "target_grp_2" {
  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
  for_each = {
    for k, v in aws_instance.target_grp_2 :
    k => v
  }
  target_group_arn = aws_lb_target_group.target_grp_2.arn
  target_id        = each.value.id
  port             = 80
}
