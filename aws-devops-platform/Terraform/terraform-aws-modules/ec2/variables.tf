variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instances"
  type        = string
  
}


variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
  
}

variable "public_subnet_ids" {
  description = "Public subnets for the instance"
  type        = list(string)
}

variable "name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "my_ec2_instance"
}