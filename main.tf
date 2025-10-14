locals {
  environment = terraform.workspace == "default" ? var.environment : terraform.workspace
  github_org  = "JoseLArantes"
  github_repo = "iac-tf-playground"
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

  enable_nat_gateway = false # Required for EB instances in private subnets

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

module "elastic_beanstalk" {
  count  = var.eb_enabled ? 1 : 0
  source = "./modules/eb"

  application_name        = var.project_name
  application_description = "Application for ${local.environment}"
  environment             = local.environment

  # Use created VPC resources
  vpc_id                          = module.vpc.vpc_id
  public_subnet_ids               = module.vpc.public_subnet_ids
  instance_security_group_id      = module.vpc.app_tier_security_group_id
  load_balancer_security_group_id = module.vpc.web_tier_security_group_id

  # Instance configuration from variables
  instance_type        = var.eb_instance_type
  ec2_key_name         = var.eb_ec2_key_name
  autoscaling_min_size = var.eb_autoscaling_min_size
  autoscaling_max_size = var.eb_autoscaling_max_size

  # Solution stack from variables
  solution_stack_name = var.eb_solution_stack_name

  # Docker configuration
  use_docker            = var.eb_use_docker
  docker_image          = var.eb_docker_image
  docker_container_port = var.eb_docker_container_port

  # Environment variables - merge defaults with custom variables
  environment_variables = merge(
    {
      ENVIRONMENT = local.environment
      APP_NAME    = var.project_name
    },
    var.eb_environment_variables
  )

  tags = local.common_tags
}

