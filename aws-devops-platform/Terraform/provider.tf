provider "aws" {
  region = var.aws_region

}

terraform {
  required_version = ">= 1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0" # Ensure this version is compatible with your Terraform version
    }
  }
}