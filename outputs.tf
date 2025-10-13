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

# EKS Outputs
# output "eks_cluster_id" {
#   description = "ID of the EKS cluster"
#   value       = try(module.principal_eks.cluster_id, null)
# }

# output "eks_cluster_endpoint" {
#   description = "Endpoint for the EKS cluster API server"
#   value       = try(module.principal_eks.cluster_endpoint, null)
# }

# output "eks_cluster_version" {
#   description = "Kubernetes version of the EKS cluster"
#   value       = try(module.principal_eks.cluster_version, null)
# }

# output "eks_cluster_security_group_id" {
#   description = "Security group ID attached to the EKS cluster"
#   value       = try(module.principal_eks.cluster_security_group_id, null)
# }

# output "eks_node_group_id" {
#   description = "ID of the EKS node group"
#   value       = try(module.principal_eks.node_group_id, null)
# }