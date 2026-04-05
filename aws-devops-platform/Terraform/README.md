# AWS DevOps Platform - Terraform

This directory contains Terraform code for provisioning AWS infrastructure components for the Cloud-Native-DevOps-Platform.

## Structure
- **main.tf**: Root module, references VPC, EKS, RDS, EC2, Lambda modules.
- **backend.tf**: Configures S3 backend for state storage and DynamoDB for state locking.
- **provider.tf**: AWS provider configuration.
- **variable.tf**: Global variables, including environment selection.
- **alb.tf**: Application Load Balancer resources and rules.
- **terraform-aws-modules/**: Contains submodules for EC2, EKS, Lambda, RDS, VPC, etc.

## Usage
1. Configure AWS credentials for Terraform.
2. Select or create a workspace for your environment (dev, staging, prod):
   ```bash
   terraform workspace new dev
   terraform workspace select dev
   ```
3. Initialize and apply:
   ```bash
   terraform init
   terraform plan -var="environment=dev"
   terraform apply -var="environment=dev"
   ```

## Notes
- State is managed in S3 with DynamoDB locking.
- Modules are reusable and can be customized per environment.

## License
MIT
