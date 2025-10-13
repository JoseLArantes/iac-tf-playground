# Principal Environment Configuration

# Global Configuration
region       = "us-east-1"
environment  = "principal"
project_name = "JLA Cloud"

# Common Tags
common_tags = {
  Project   = "JLA Cloud"
  ManagedBy = "terraform"
  terraform = "true"
}

# Networking Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

