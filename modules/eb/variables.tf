# Elastic Beanstalk Module Variables

variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
}

variable "application_description" {
  description = "Description of the Elastic Beanstalk application"
  type        = string
  default     = "Elastic Beanstalk Application"
}

variable "environment" {
  description = "Environment name (dev, staging, principal)"
  type        = string
}

variable "solution_stack_name" {
  description = "Elastic Beanstalk solution stack name"
  type        = string
  default     = "64bit Amazon Linux 2023 v4.7.2 running Docker"
}

variable "use_docker" {
  description = "Whether to use Docker for deployment"
  type        = bool
  default     = true
}

variable "docker_image" {
  description = "Docker image URI from ECR (e.g., 123456789.dkr.ecr.region.amazonaws.com/image:tag)"
  type        = string
  default     = ""
}

variable "docker_container_port" {
  description = "Port that the Docker container exposes"
  type        = number
  default     = 8000
}

variable "tier" {
  description = "Elastic Beanstalk environment tier (WebServer or Worker)"
  type        = string
  default     = "WebServer"
}

variable "environment_type" {
  description = "Environment type (LoadBalanced or SingleInstance)"
  type        = string
  default     = "LoadBalanced"
}

# Networking
variable "vpc_id" {
  description = "VPC ID where Elastic Beanstalk will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for load balancer"
  type        = list(string)
}

variable "instance_security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "load_balancer_security_group_id" {
  description = "Security group ID for load balancer"
  type        = string
}

# Instance Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "EC2 key pair name for SSH access to instances"
  type        = string
  default     = ""
}

# Auto Scaling
variable "autoscaling_min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "autoscaling_max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

# Load Balancer
variable "load_balancer_type" {
  description = "Load balancer type (application or network)"
  type        = string
  default     = "application"
}

# Application Versions
variable "appversion_max_count" {
  description = "Maximum number of application versions to keep"
  type        = number
  default     = 10
}

variable "appversion_delete_source" {
  description = "Delete application version source bundle from S3"
  type        = bool
  default     = true
}

# Managed Actions
variable "enable_managed_actions" {
  description = "Enable managed platform updates"
  type        = bool
  default     = true
}

variable "preferred_start_time" {
  description = "Preferred start time for managed actions (day:hour:minute format)"
  type        = string
  default     = "Sun:10:00"
}

variable "update_level" {
  description = "Update level for platform updates (minor or patch)"
  type        = string
  default     = "patch"
}

# Rolling Updates
variable "rolling_update_enabled" {
  description = "Enable rolling updates"
  type        = bool
  default     = true
}

variable "rolling_update_type" {
  description = "Rolling update type (Health, Time, or Immutable)"
  type        = string
  default     = "Health"
}

# CloudWatch Logs
variable "enable_log_streaming" {
  description = "Enable CloudWatch log streaming"
  type        = bool
  default     = true
}

variable "logs_delete_on_terminate" {
  description = "Delete logs on environment termination"
  type        = bool
  default     = false
}

variable "logs_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 7
}

# Environment Variables
variable "environment_variables" {
  description = "Map of environment variables for the application"
  type        = map(string)
  default     = {}
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

