# Global configs
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "JLA Cloud"
    ManagedBy = "terraform"
    terraform = "true"
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "JLA Cloud"
}

variable "environment" {
  description = "Environment name (dev, principal)"
  type        = string
  default     = ""
}

# Networking

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# Elastic Beanstalk Configuration
variable "eb_enabled" {
  description = "Enable Elastic Beanstalk deployment"
  type        = bool
  default     = false
}

variable "eb_instance_type" {
  description = "EC2 instance type for Elastic Beanstalk"
  type        = string
  default     = "t3.micro"
}

variable "eb_ec2_key_name" {
  description = "EC2 key pair name for SSH access to Elastic Beanstalk instances"
  type        = string
  default     = ""
}

variable "eb_autoscaling_min_size" {
  description = "Minimum number of instances for Elastic Beanstalk"
  type        = number
  default     = 1
}

variable "eb_autoscaling_max_size" {
  description = "Maximum number of instances for Elastic Beanstalk"
  type        = number
  default     = 4
}

variable "eb_solution_stack_name" {
  description = "Elastic Beanstalk solution stack name"
  type        = string
  default     = "64bit Amazon Linux 2023 v4.7.2 running Docker"
}

variable "eb_use_docker" {
  description = "Whether to use Docker for Elastic Beanstalk deployment"
  type        = bool
  default     = true
}

variable "eb_docker_image" {
  description = "Docker image URI from ECR"
  type        = string
  default     = ""
}

variable "eb_docker_container_port" {
  description = "Port that the Docker container exposes"
  type        = number
  default     = 8000
}

variable "eb_environment_variables" {
  description = "Environment variables for Elastic Beanstalk application"
  type        = map(string)
  default     = {}
}
