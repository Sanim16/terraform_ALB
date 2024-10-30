resource "aws_security_group" "alb" {
  name        = "terraform-${var.vpc_name}-alb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "ALB egress rule"
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
  description       = "ALB HTTP Ingress rule"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb-https" {
  security_group_id = aws_security_group.alb.id
  description       = "ALB HTTPS ingress rule"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "instances-ssh" {
  security_group_id = aws_security_group.instances.id
  description       = "Instances SSH ingress rule"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "instances-http" {
  security_group_id = aws_security_group.instances.id
  description       = "Instances HTTP Ingress rule"

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "instances-https" {
  security_group_id = aws_security_group.instances.id
  description       = "Instances HTTPS Ingress rule"

  referenced_security_group_id = aws_security_group.alb.id
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
