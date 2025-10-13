# EKS Outputs
output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = try(module.principal_eks.cluster_id, null)
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server"
  value       = try(module.principal_eks.cluster_endpoint, null)
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = try(module.principal_eks.cluster_version, null)
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = try(module.principal_eks.cluster_security_group_id, null)
}

output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = try(module.principal_eks.node_group_id, null)
}