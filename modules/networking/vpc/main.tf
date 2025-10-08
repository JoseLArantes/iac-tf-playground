# VPC Module - Main Configuration
# Creates VPC with configurable CIDR and basic networking components

# VPC Resource
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

module "sg_base" {
  source         = "../sgs"
  vpc_id         = aws_vpc.main.id
  sg_name        = "${var.environment}-base"
  sg_description = "Base security group for ${var.environment}"
  tags           = var.tags
}

# Internet Gateway for public internet access
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-igw"
  })
}

# Data source to get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Note: Local values are defined in locals.tf

# Public Subnets - distributed across multiple availability zones
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index % length(local.selected_azs)]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
    Type = "Public"
    AZ   = local.selected_azs[count.index % length(local.selected_azs)]
  })
}

# Private Subnets - distributed across multiple availability zones
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.selected_azs[count.index % length(local.selected_azs)]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
    Type = "Private"
    AZ   = local.selected_azs[count.index % length(local.selected_azs)]
  })
}
# Security Group for Web Tier (Load Balancers, Public-facing services)
resource "aws_security_group" "web_tier" {
  name_prefix = "${var.name_prefix}-web-tier-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for web tier - load balancers and public services"

  # HTTP access from internet
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from internet
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web-tier-sg"
    Tier = "Web"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for Application Tier (Private services, databases)
resource "aws_security_group" "app_tier" {
  name_prefix = "${var.name_prefix}-app-tier-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for application tier - private services and databases"

  # Allow traffic from web tier
  ingress {
    description     = "Traffic from web tier"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  # Allow traffic within application tier
  ingress {
    description = "Traffic within application tier"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-tier-sg"
    Tier = "Application"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-rt"
    Type = "Public"
  })
}

# Route table associations for public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-rt"
    Type = "Private"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}