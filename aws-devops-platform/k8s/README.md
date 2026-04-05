# Kubernetes Resources for Cloud-Native-DevOps-Platform

This directory contains Kubernetes manifests for configuring and managing resources on your EKS cluster.

## Structure
- **eks-admin-binding.yaml**: ClusterRoleBinding for EKS admin access.
- **irsa-service-account.yml**: ServiceAccount for IAM Roles for Service Accounts (IRSA).

## Usage
Apply resources with kubectl:
```bash
kubectl apply -f eks-admin-binding.yaml
kubectl apply -f irsa-service-account.yml
```

## License
MIT
