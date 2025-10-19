# AWS DevOps Platform - Ansible

This directory contains Ansible playbooks, roles, and configuration files for automating the deployment and management of the AWS DevOps Platform.

## Structure
- **ansible.cfg**: Ansible configuration file.
- **inventory/aws_ec2.yml**: Dynamic inventory for AWS EC2 instances.
- **playbooks/site.yml**: Main playbook to orchestrate roles and tasks.
- **roles/app/**: Contains tasks, handlers, defaults, and templates for the application deployment.

## Usage
1. **Configure AWS credentials** for Ansible to access your AWS resources.
2. **Edit inventory/aws_ec2.yml** to match your AWS environment.
3. **Run the main playbook:**
   ```bash
   ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
   ```

## Roles
- **app**: Deploys and configures the cloud application (Flask + Gunicorn) on target EC2 instances.

## Templates
- **cloud-app.env.j2**: Environment variables for the app.
- **cloud-app.service.j2**: Systemd service file for the app.

## Requirements
- Ansible 2.9+
- Python 3.6+
- AWS CLI configured (for dynamic inventory)

## Artifact Storage
- **GitHub Container Registry (ghcr.io)**: Recommended for storing container images. Free for public images, supports versioning and access control.
- To push images from GitHub Actions, use the following steps:

```yaml
- name: Log in to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Build and push Docker image
  run: |
    docker build -t ghcr.io/${{ github.repository }}/cloud-app-backend:latest aws-devops-platform/cloud-app/backend
    docker push ghcr.io/${{ github.repository }}/cloud-app-backend:latest
```

## Notes
- Ensure your EC2 instances are accessible and have the required permissions.
- Customize variables in `roles/app/defaults/main.yml` as needed.

## License
MIT
