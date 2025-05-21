# Insurance Project Infrastructure

This directory contains the infrastructure as code (IaC) for the Insurance Project.

## Directory Structure

```
infrastructure/
├── ansible/
│   └── ansible-playbook.yml    # Ansible playbook for configuring instances
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output configurations
│   ├── security.tf            # Security group configurations
│   ├── inventory.tmpl         # Template for Ansible inventory
│   └── terraform.tfvars       # Variable values
├── infra.sh                   # Main deployment script
└── README.md                  # This file
```

## Prerequisites

1. Install required tools:
   ```bash
   # Install Terraform
   sudo apt-get update && sudo apt-get install -y terraform

   # Install Ansible
   sudo apt-get install -y ansible

   # Install jq (required for script)
   sudo apt-get install -y jq
   ```

2. Configure AWS credentials:
   ```bash
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   ```

3. Add your SSH public key to `terraform/terraform.tfvars`:
   ```hcl
   ssh_public_key = "ssh-rsa AAAA... your-key-here"
   ```

## Usage

1. Run the deployment script:
   ```bash
   ./infra.sh
   ```

2. After successful deployment, you can access:
   - Jenkins: http://<master-ip>:8080
   - Application: http://<master-ip>:8084

## Clean Up

To destroy the infrastructure:
```bash
cd terraform
terraform destroy
```

## Notes

- The master node is a t2.large instance
- Worker nodes are t2.medium instances
- All instances use Ubuntu AMI
- Jenkins and Docker are automatically installed and configured
- The insurance application is deployed as a Docker container
