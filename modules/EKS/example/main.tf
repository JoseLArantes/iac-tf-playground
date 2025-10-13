module "principal_eks" {
  source = "./modules/EKS"

  cluster_name = "${local.environment}-eks-cluster"
  subnet_ids   = module.vpc.public_subnet_ids

  kubernetes_version      = "1.31"
  endpoint_private_access = false
  endpoint_public_access  = true

  node_instance_types = ["t3.micro"]
  node_capacity_type  = "ON_DEMAND"
  node_desired_size   = 1
  node_max_size       = 1
  node_min_size       = 1
  node_disk_size      = 20

  tags = local.common_tags
}
