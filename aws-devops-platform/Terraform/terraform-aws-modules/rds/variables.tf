variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "cloudnativedevopsplatform"
  
}
variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Private subnets for the EKS cluster"
  type        = list(string)
}