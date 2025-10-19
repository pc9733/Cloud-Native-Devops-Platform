# GitOps with Flux for EKS

Flux is a GitOps tool that automates deployment of Kubernetes manifests from a Git repository to your EKS cluster. This guide helps you bootstrap Flux and organize your manifests for dev, staging, and prod environments.

## Prerequisites
- EKS cluster provisioned (see Terraform configs)
- kubectl configured for your cluster
- GitHub repository for Kubernetes manifests (e.g., cloud-native-devops-platform-infra)

## Install Flux
```bash
kubectl create namespace flux-system
curl -s https://fluxcd.io/install.sh | sudo bash
flux install --namespace=flux-system
```

## Bootstrap Flux with your Git repo
```bash
flux bootstrap github \
  --owner=<your-github-username> \
  --repository=cloud-native-devops-platform-infra \
  --branch=main \
  --path=clusters/eks-prod \
  --personal
```

## Directory structure for manifests repo
```
cloud-native-devops-platform-infra/
  clusters/
    eks-dev/
      kustomization.yaml
      app-deployment.yaml
      ...
    eks-prod/
      kustomization.yaml
      app-deployment.yaml
      ...
```

## Example kustomization.yaml
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: app
  namespace: flux-system
spec:
  interval: 10m
  path: ./app-deployment.yaml
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
    namespace: flux-system
```

## Next steps
- Commit your Kubernetes manifests and Helm charts to the repo.
- Flux will automatically sync changes to your cluster.
- Use separate directories for dev, staging, and prod environments.

## References
- https://fluxcd.io/docs/
- https://github.com/fluxcd/flux2
