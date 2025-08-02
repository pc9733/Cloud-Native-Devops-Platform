# EKS module configuration
module "eks" {
    source          = "terraform-aws-modules/eks/aws" # Source of the EKS module
    version         = "20.8.4"                        # Module version

    enable_irsa = true # Enable IAM roles for service accounts

    cluster_name    = "cloudnativedevopsplatformeks" # Name of the EKS cluster
    cluster_version = "1.27"                             # Kubernetes version

    subnet_ids      = var.subnet_ids # Subnets for EKS cluster
    vpc_id          = var.vpc_id     # VPC for EKS cluster

    eks_managed_node_groups = {
        dev = {
            instance_types = ["t3.medium"] # EC2 instance type for node group
            desired_size   = 2             # Desired number of nodes
            ami_type       = "AL2_x86_64"
        }
    }

    tags = {
        Environment = "dev"                         # Environment tag
        Project     = "cloud-native-devops-platform" # Project tag
    }
}
