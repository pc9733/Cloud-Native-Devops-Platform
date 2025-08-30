variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instances"
  type        = string
  default     = "cloudnative"
}