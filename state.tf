terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    # Configuration loaded from environments/*.tfbackend
    # Example: terraform init -backend-config="environments/environment.tfbackend"
  }
}

