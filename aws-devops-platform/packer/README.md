# Packer AMI Build for Cloud-Native-DevOps-Platform

This directory contains Packer templates for building custom AMIs for use in AWS EC2 instances.

## Structure
- **packer-ami-docker.json**: Packer template for building a Docker-enabled AMI.
- **Readme.txt**: Additional notes or instructions.

## Usage
1. Install Packer: https://www.packer.io/downloads
2. Build the AMI:
   ```bash
   packer build packer-ami-docker.json
   ```

## License
MIT
