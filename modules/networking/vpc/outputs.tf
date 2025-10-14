# VPC Module Outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = try(aws_nat_gateway.main[0].id, null)
}

output "nat_gateway_eip" {
  description = "Elastic IP address of the NAT Gateway"
  value       = try(aws_eip.nat[0].public_ip, null)
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "web_tier_security_group_id" {
  description = "ID of the web tier security group"
  value       = aws_security_group.web_tier.id
}

output "app_tier_security_group_id" {
  description = "ID of the application tier security group"
  value       = aws_security_group.app_tier.id
}

output "availability_zones" {
  description = "List of availability zones used by subnets"
  value       = local.selected_azs
}

output "public_subnet_availability_zones" {
  description = "List of availability zones for public subnets"
  value       = aws_subnet.public[*].availability_zone
}

output "private_subnet_availability_zones" {
  description = "List of availability zones for private subnets"
  value       = aws_subnet.private[*].availability_zone
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "all_security_group_ids" {
  description = "Map of all security group IDs created by this module"
  value = {
    web_tier = aws_security_group.web_tier.id
    app_tier = aws_security_group.app_tier.id
  }
}

output "subnet_ids_by_type" {
  description = "Map of subnet IDs organized by type"
  value = {
    public  = aws_subnet.public[*].id
    private = aws_subnet.private[*].id
  }
}

output "route_table_ids_by_type" {
  description = "Map of route table IDs organized by type"
  value = {
    public  = [aws_route_table.public.id]
    private = aws_route_table.private[*].id
  }
}

output "vpc_info" {
  description = "Complete VPC information summary"
  value = {
    vpc_id             = aws_vpc.main.id
    vpc_cidr           = aws_vpc.main.cidr_block
    availability_zones = local.selected_azs
    public_subnets     = length(aws_subnet.public)
    private_subnets    = length(aws_subnet.private)
    internet_gateway   = aws_internet_gateway.main.id
  }
}
