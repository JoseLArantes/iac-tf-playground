# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = try(module.vpc.vpc_cidr_block, null)
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = try(module.vpc.public_subnet_ids, [])
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = try(module.vpc.private_subnet_ids, [])
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = try(module.vpc.internet_gateway_id, null)
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = try(module.vpc.nat_gateway_id, null)
}

output "nat_gateway_ip" {
  description = "Elastic IP of the NAT Gateway"
  value       = try(module.vpc.nat_gateway_eip, null)
}

output "s3_iac_bucket_name" {
  description = "Name of the S3 bucket for terraform state"
  value       = try(module.s3_iac.bucket_name, null)
}

output "github_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = module.github_oidc.role_arn
}

output "github_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.github_oidc.provider_arn
}

# Elastic Beanstalk Outputs
output "eb_application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = var.eb_enabled ? module.elastic_beanstalk[0].application_name : null
}

output "eb_environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = var.eb_enabled ? module.elastic_beanstalk[0].environment_name : null
}

output "eb_environment_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = var.eb_enabled ? module.elastic_beanstalk[0].environment_cname : null
}

output "eb_endpoint_url" {
  description = "Fully qualified DNS name for the Elastic Beanstalk environment"
  value       = var.eb_enabled ? module.elastic_beanstalk[0].environment_endpoint_url : null
}