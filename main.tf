data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_instance" "target_grp_1" {
#   count         = 2
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   subnet_id     = module.vpc.public_subnets[0]

#   vpc_security_group_ids = [aws_security_group.instances.id]

#   associate_public_ip_address = true

#   key_name = "terraformkey"

#   tags = {
#     Name = "main"
#   }

#   user_data = file("bootstrap1.sh")
# }

data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resource "aws_instance" "target_grp_2" {
#   count         = 2
#   ami           = data.aws_ami.amazon.id
#   instance_type = "t2.micro"
#   subnet_id     = module.vpc.public_subnets[1]

#   vpc_security_group_ids = [aws_security_group.instances.id]

#   associate_public_ip_address = true

#   key_name = "terraformkey"

#   tags = {
#     Name = "amazon"
#   }

#   user_data = file("bootstrap2.sh")
# }

# resource "aws_instance" "target_grp_default" {
#   count         = 2
#   ami           = data.aws_ami.amazon.id
#   instance_type = "t2.micro"
#   subnet_id     = module.vpc.public_subnets[2]

#   vpc_security_group_ids = [aws_security_group.instances.id]

#   associate_public_ip_address = true

#   key_name = "terraformkey"

#   tags = {
#     Name  = "amazon"
#     Group = "default"
#   }

#   user_data = file("bootstrap.sh")
# }

resource "aws_security_group" "instances" {
  name        = "terraform-${var.vpc_name}-instances"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-${var.vpc_name}-instances"
  }
}
