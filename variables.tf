variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc_name" {
  description = "VPC name"
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnets_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "alb_name" {
  description = "Application Load Balancer name"
  default     = "my-alb"
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  default     = "my-asg"
}

variable "lc_name" {
  description = "Launch Configuration name"
  default     = "my-lc"
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  default     = 2
}

variable "health_check_grace_period" {
  description = "Health check grace period"
  default     = 300
}

variable "wait_for_capacity_timeout" {
  description = "Timeout value for waiting for capacity"
  default     = "10m"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  default     = "my-key-pair"
}

variable "root_volume_size" {
  description = "Size of the root volume (in GB)"
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "sg_name" {
  description = "Name of the security group"
  default     = "web-server-sg"
}

variable "environment" {
  description = "Environment (e.g., production, staging)"
  default     = "dev"
}

variable "route53_private_zone_name" {
  description = "Name for the private Route 53 hosted zone"
  default     = "test.example.com."
}

variable "test_example_com_hostname" {
  description = "Hostname for the test.example.com DNS record"
  default     = "test.example.com"
}
