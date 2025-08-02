module "vpc" {
  source = "./terraform-aws-modules/vpc/"
}
module "eks" {
  source     = "./terraform-aws-modules/eks/"
  vpc_id     = module.vpc.subnet_and_cidr.vpc_id
  subnet_ids = module.vpc.subnet_and_cidr.private_subnets
}
module "rds" {
  source = "./terraform-aws-modules/rds/"
}