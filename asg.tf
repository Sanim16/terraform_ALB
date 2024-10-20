resource "aws_autoscaling_group" "target_grp_default" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.target_grp_default.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "target_grp_default" {
  name = "target-grp-default"

  image_id = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  key_name = "terraformkey"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = module.vpc.public_subnets[2]
    security_groups = [ aws_security_group.instances.id ]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "amazon"
      Group = "target-grp-default"
    }
  }

  user_data = filebase64("bootstrap.sh")
}

resource "aws_autoscaling_attachment" "target_grp_default" {
  autoscaling_group_name = aws_autoscaling_group.target_grp_default.id
  lb_target_group_arn    = aws_lb_target_group.target_grp_default.arn
}

resource "aws_autoscaling_group" "target_grp_1" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.target_grp_1.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "target_grp_1" {
  name = "target-grp-1"

  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "terraformkey"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = module.vpc.public_subnets[0]
    security_groups = [ aws_security_group.instances.id ]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ubuntu"
      Group = "target-grp-1"
    }
  }

  user_data = filebase64("bootstrap1.sh")
}

resource "aws_autoscaling_attachment" "target_grp_1" {
  autoscaling_group_name = aws_autoscaling_group.target_grp_1.id
  lb_target_group_arn    = aws_lb_target_group.target_grp_1.arn
}

resource "aws_autoscaling_group" "target_grp_2" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.target_grp_2.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "target_grp_2" {
  name = "target-grp-2"

  image_id = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  key_name = "terraformkey"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = module.vpc.public_subnets[1]
    security_groups = [ aws_security_group.instances.id ]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "amazon"
      Group = "target-grp-2"
    }
  }

  user_data = filebase64("bootstrap2.sh")
}

resource "aws_autoscaling_attachment" "target_grp_2" {
  autoscaling_group_name = aws_autoscaling_group.target_grp_2.id
  lb_target_group_arn    = aws_lb_target_group.target_grp_2.arn
}
