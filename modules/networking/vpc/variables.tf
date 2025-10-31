variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jla-aws"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets (optional - will use all available if not specified)"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name (dev, principal)"
  type        = string
  default     = ""
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "sg_description" {
  description = "Description for the security group"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets internet access"
  type        = bool
  default     = true
}