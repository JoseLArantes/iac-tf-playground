locals {
  environment            = terraform.workspace == "default" ? var.environment : terraform.workspace
  github_org             = "JoseLArantes"
  github_repo            = "iac-tf-playground"
  # Merge common tags with environment-specific tags
  common_tags = merge(var.common_tags, {
    Environment = local.environment
    Workspace   = terraform.workspace
    DeployedBy  = "terraform"
    # DeployedAt  = timestamp()
  })
}

module "s3_iac" {
  source = "./modules/s3"

  bucket_name = "${lower(replace(var.project_name, " ", "-"))}-${local.environment}-state"
  environment = local.environment
  tags        = local.common_tags
}

module "vpc" {
  source = "./modules/networking/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  sg_name        = "${local.environment}-base"
  sg_description = "Base security group for ${local.environment}"

  environment = local.environment
  tags        = local.common_tags
}

module "github_oidc" {
  source = "./modules/IAM/identity-providers"

  idp_name    = "${local.environment}-github-actions"
  github_org  = local.github_org
  github_repo = local.github_repo

  tags = local.common_tags
}
