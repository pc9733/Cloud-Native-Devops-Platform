terraform {
  backend "s3" {
    bucket         = "cloudnativedevopsplatformbucket"
    key            = "cloud-native-devops-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}