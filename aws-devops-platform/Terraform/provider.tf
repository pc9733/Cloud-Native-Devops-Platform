provider "aws" {
  region = var.aws_region

}

terraform {
  required_version = ">= 1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0" # ✅ Compatible with all terraform-aws-modules
    }
  }
}