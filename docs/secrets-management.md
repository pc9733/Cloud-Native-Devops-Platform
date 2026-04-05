# Secrets & Configuration Management for Cloud-Native-DevOps-Platform

## Recommended Tools
- **AWS Secrets Manager**: Store sensitive credentials securely in AWS.
- **HashiCorp Vault**: Self-hosted secrets management (optional).
- **SOPS**: Encrypt secrets in Git, integrates with AWS KMS.
- **Kubernetes External Secrets Operator**: Sync secrets from AWS Secrets Manager into Kubernetes as native secrets.

## Example: Using AWS Secrets Manager with External Secrets Operator

1. **Install External Secrets Operator on EKS**
   ```bash
   kubectl apply -f https://github.com/external-secrets/external-secrets/releases/latest/download/crds.yaml
   helm repo add external-secrets https://charts.external-secrets.io
   helm install external-secrets external-secrets/external-secrets --namespace external-secrets --create-namespace
   ```

2. **Create an AWS Secret**
   ```bash
   aws secretsmanager create-secret --name cloud-app-db-password --secret-string 'supersecretpassword'
   ```

3. **Create an ExternalSecret manifest**
   ```yaml
   apiVersion: external-secrets.io/v1beta1
   kind: ExternalSecret
   metadata:
     name: cloud-app-db-password
     namespace: default
   spec:
     refreshInterval: 1h
     secretStoreRef:
       name: aws-secrets-manager
       kind: SecretStore
     target:
       name: cloud-app-db-password
       creationPolicy: Owner
     data:
       - secretKey: password
         remoteRef:
           key: cloud-app-db-password
   ```

4. **Encrypt secrets in Git with SOPS**
   - Use SOPS to encrypt Kubernetes secrets manifests before committing to Git.
   - Integrate with AWS KMS for key management.

## References
- https://github.com/external-secrets/kubernetes-external-secrets
- https://github.com/mozilla/sops
- https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
