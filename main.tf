provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = var.vpc_name

  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
  }
}

module "load_balancer" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name               = var.alb_name
  security_groups    = [module.web_server_sg.security_group_id]
  subnets            = module.vpc.public_subnets
  internal           = false
  idle_timeout       = 60
  load_balancer_type = "application"

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
  }
}

resource "aws_launch_template" "web_server_lt" {
  name_prefix   = var.lc_name
  image_id      = data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.root_volume_size
      volume_type = var.root_volume_type
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.lc_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
  name                        = var.asg_name
  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

  min_size                    = var.min_size
  max_size                    = var.max_size
  desired_capacity            = var.desired_capacity
  vpc_zone_identifier         = module.vpc.private_subnets
  health_check_type           = "ELB"
  health_check_grace_period   = var.health_check_grace_period
  wait_for_capacity_timeout  = var.wait_for_capacity_timeout

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "web_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = var.sg_name
  description = "Security group for web server"

  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
    }
  ]

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
  }
}

output "asg_name" {
  value       = aws_autoscaling_group.web_server_asg.name
}

output "lc_name" {
  value       = aws_launch_template.web_server_lt.name
}

output "web_server_security_group_id" {
  value       = module.web_server_sg.security_group_id
}
