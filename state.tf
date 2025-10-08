terraform {
  required_version = ">= 1.5.0"  

  backend "s3" {
    bucket  = "jla-cloud-principal-state"
    key     = "global/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}