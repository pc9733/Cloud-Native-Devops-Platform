# Monitoring and Logging for Cloud-Native-DevOps-Platform

## Recommended Stack
- **Prometheus Operator**: For metrics collection and alerting
- **Grafana**: For dashboards and visualization
- **Grafana Cloud (optional)**: Free tier for managed metrics/logs
- **Alertmanager**: For notifications (Slack, Email, etc.)
- **Loki**: For log aggregation (optional)

## Quickstart: Prometheus & Grafana on EKS

1. **Add Helm repo and install Prometheus Operator**
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
   ```

2. **Install Grafana** (included in kube-prometheus-stack)
   - Get Grafana admin password:
     ```bash
     kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
     ```
   - Port-forward Grafana UI:
     ```bash
     kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
     ```
   - Access Grafana at http://localhost:3000

3. **Configure Alertmanager**
   - Edit `alertmanager.yaml` in the Helm chart values to add Slack/Email configs.

4. **Optional: Integrate with Grafana Cloud**
   - Sign up for Grafana Cloud (free tier)
   - Add Prometheus/Grafana Cloud endpoints in Helm values

5. **Log aggregation (optional)**
   - Install Loki via Helm:
     ```bash
     helm repo add grafana https://grafana.github.io/helm-charts
     helm install loki grafana/loki-stack --namespace monitoring
     ```

## References
- https://prometheus.io/docs/prometheus/latest/getting_started/
- https://grafana.com/docs/grafana/latest/getting-started/
- https://github.com/prometheus-community/helm-charts
- https://grafana.com/products/cloud/

## Example Helm values for Alertmanager (Slack)
```yaml
alertmanager:
  config:
    global:
      resolve_timeout: 5m
    route:
      receiver: 'slack-notifications'
    receivers:
      - name: 'slack-notifications'
        slack_configs:
          - api_url: '<your-slack-webhook-url>'
            channel: '#alerts'
```
