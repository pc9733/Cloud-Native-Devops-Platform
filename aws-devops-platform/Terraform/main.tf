module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    }
module "eks" {
  source = "terraform-aws-modules/eks/aws"
}
module "rds" {
    source = "terraform-aws-modules/rds/aws"
    identifier = "my-rds-instance"
}