terraform {
  backend "s3" {
    bucket         = "jla-cloud-principal-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}