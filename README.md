# Terraform Module for Web Application Deployment

This Terraform module deploys a web application on AWS with the following design:

1. It includes a VPC which enables future growth / scale.
2. It includes both a public and private subnet – where the private subnet is used for compute and the public is used for the load balancers.
3. It has a security group scheme which supports the minimal set of ports required for communication.
4. The AWS generated load balancer hostname is used for requests to the public facing web application.
5. An autoscaling group is created which utilizes the latest AWS AMI.
6. The instance in the ASG contains both a root volume to store the application / services and a secondary volume to store any log data bound from /var/log.
7. It includes a web server of your choice.
8. The web application is configured using Ansible. All requirements for configuring the operating system are defined in the launch configuration and/or the user data script.
9. A self-signed certificate for test.example.com is created and used. This hostname is associated with the Load Balancer. The DNS is resolved internally within the VPC network using Route 53 private hosted zone.

## Module Inputs

- `aws_region`: AWS region where the resources will be deployed.
- `vpc_name`: Name for the VPC.
- `vpc_cidr`: CIDR block for the VPC.
- `availability_zones`: List of availability zones.
- `public_subnets_cidr_blocks`: CIDR blocks for the public subnets.
- `private_subnets_cidr_blocks`: CIDR blocks for the private subnets.
- `alb_name`: Name for the Application Load Balancer.
- `asg_name`: Name for the Auto Scaling Group.
- `lc_name`: Name for the Launch Configuration.
- `min_size`: Minimum size of the Auto Scaling Group.
- `max_size`: Maximum size of the Auto Scaling Group.
- `desired_capacity`: Desired capacity of the Auto Scaling Group.
- `health_check_grace_period`: Health check grace period.
- `wait_for_capacity_timeout`: Timeout value for waiting for capacity.
- `instance_type`: EC2 instance type.
- `key_name`: EC2 key pair name.
- `root_volume_size`: Size of the root volume (in GB).
- `root_volume_type`: Type of the root volume.
- `sg_name`: Name of the security group.
- `environment`: Environment (e.g., production, staging).
- `route53_private_zone_name`: Name for the private Route 53 hosted zone.
- `test_example_com_hostname`: Hostname for the test.example.com DNS record.

## Important Design Decisions

- **VPC Design**: The module creates a VPC with public and private subnets across multiple availability zones to ensure high availability and fault tolerance.
- **Security Group Scheme**: The security group allows inbound traffic on port 80 (HTTP) and port 443 (HTTPS) to the web servers, and all outbound traffic.
- **Autoscaling Group**: An autoscaling group is created to automatically adjust the number of instances in response to demand or in the event of an instance failure.
- **Instance Configuration**: The instances launched in the autoscaling group have both a root volume for storing the application/services and a secondary volume for storing log data.
- **Web Server**: A web server of your choice is deployed on the EC2 instances.
- **Configuration Management**: Ansible is used for configuring the operating system and the web application.
- **Self-signed Certificate**: A self-signed certificate for test.example.com is created and associated with the Load Balancer. The DNS is resolved internally within the VPC network using Route 53 private hosted zone.

## Outputs

- `alb_dns_name`: DNS name of the Application Load Balancer.
- `asg_name`: Name of the Auto Scaling Group.
- `lc_name`: Name of the Launch Configuration.
- `vpc_id`: ID of the VPC.
- `public_subnet_ids`: IDs of the public subnets.
- `private_subnet_ids`: IDs of the private subnets.
- `web_server_security_group_id`: ID of the security group for the web server.
- `private_zone_id`: ID of the private Route 53 hosted zone.

## Usage Example

```hcl
module "web_app" {
  source = "path/to/module"

  aws_region = "us-west-2"
  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  alb_name = "my-alb"
  asg_name = "my-asg"
  lc_name = "my-lc"
  min_size = 1
  max_size = 3
  desired_capacity = 2
  health_check_grace_period = 300
  wait_for_capacity_timeout = "10m"
  instance_type = "t2.micro"
  key_name = "my-key-pair"
  root_volume_size = 20
  root_volume_type = "gp2"
  sg_name = "web-server-sg"
  environment = "dev"
  route53_private_zone_name = "test.example.com."
  test_example_com_hostname = "test.example.com"
}

output "alb_dns_name" {
  value = module.web_app.alb_dns_name
}

output "asg_name" {
  value = module.web_app.asg_name
}

output "lc_name" {
  value = module.web_app.lc_name
}

output "vpc_id" {
  value = module.web_app.vpc_id
}

output "public_subnet_ids" {
  value = module.web_app.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.web_app.private_subnet_ids
}

output "web_server_security_group_id" {
  value = module.web_app.web_server_security_group_id
}

output "private_zone_id" {
  value = module.web_app.private_zone_id
}
