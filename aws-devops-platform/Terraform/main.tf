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
  public_subnet_ids         = module.vpc.subnet_and_cidr.public_subnets
  vpc_id                    = module.vpc.subnet_and_cidr.vpc_id
}

module "ec2" {
   source = "./terraform-aws-modules/ec2/"
   public_subnet_ids  = module.vpc.subnet_and_cidr.public_subnets
   vpc_id             = module.vpc.subnet_and_cidr.vpc_id
   key_name           = var.key_name  # Ensure you have a valid key pair
}