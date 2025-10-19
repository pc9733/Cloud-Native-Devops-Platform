# Environment Strategy for Cloud-Native-DevOps-Platform

## Recommended Practices
- Use separate Terraform workspaces and variables for dev, staging, and prod environments.
- Use separate Kubernetes namespaces for each environment.
- Implement branch-based deployments in CI/CD workflows.

## Example: Terraform Workspaces
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
terraform workspace select dev
terraform apply -var="environment=dev"
```

## Example: Kubernetes Namespaces
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: staging
---
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

## Example: Branch-based CI/CD
- Feature branches: run CI only
- Merges to `dev`: deploy to dev environment
- Merges to `main`: deploy to staging, promote to prod via manual approval

## Directory Structure for Manifests
```
cloud-native-devops-platform-infra/
  clusters/
    eks-dev/
    eks-staging/
    eks-prod/
```

## References
- https://www.terraform.io/docs/language/state/workspaces.html
- https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
