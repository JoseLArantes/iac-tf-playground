# EKS Cluster Outputs

output "cluster_id" {
  description = "Id of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  description = "ARN of the cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_endpoint" {
  description = "Endpoint Kubernetes API server"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
  description = "Server version"
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_security_group_id" {
  description = "Security group ID attached"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive   = true
}

output "cluster_iam_role_arn" {
  description = "IAM role of the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_id" {
  description = "EKS node group id"
  value       = aws_eks_node_group.minimal.id
}

output "node_group_arn" {
  description = "ARN of the EKS Node Group"
  value       = aws_eks_node_group.minimal.arn
}

output "node_group_status" {
  description = "Status of the node group"
  value       = aws_eks_node_group.minimal.status
}

output "node_iam_role_arn" {
  description = "IAM role ARN of the node group"
  value       = aws_iam_role.eks_node_role.arn
}

