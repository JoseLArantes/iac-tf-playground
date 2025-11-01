# Dev Environment Configuration

# Global Configuration
region       = "us-east-1"
environment  = "dev"
project_name = "JLA Cloud"

# Common Tags
common_tags = {
  Project   = "JLA Cloud"
  ManagedBy = "terraform"
  terraform = "true"
}

# Networking Configuration
vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]

# Elastic Beanstalk Configuration
eb_enabled              = false # Set to true to enable Elastic Beanstalk
eb_instance_type        = "t3.micro"
eb_ec2_key_name         = "joseluiz"
eb_autoscaling_min_size = 1
eb_autoscaling_max_size = 1

# Docker Configuration
eb_use_docker            = true
eb_solution_stack_name   = "64bit Amazon Linux 2023 v4.7.2 running Docker"
eb_docker_image          = "690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:nginx"
eb_docker_container_port = 80

# Application Environment Variables
eb_environment_variables = {
  # Add your custom environment variables here
  # DATABASE_HOST = "db.example.com"
  # API_KEY = "your-api-key"
}

