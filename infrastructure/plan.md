# Terraform Infrastructure Plan for Insurance Project

## Overview
This plan outlines the creation of 3 EC2 instances in AWS using Terraform:
- 1 Master node (t2.large)
- 2 Worker nodes (t2.medium)

## Directory Structure
```
terraform/
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output configurations
├── security.tf       # Security group configurations
└── terraform.tfvars  # Variable values
```

## Resource Details

### 1. VPC and Network Configuration
- Create a VPC with CIDR block 10.0.0.0/16
- Create public subnet in different availability zones
- Create Internet Gateway
- Create Route Table

### 2. Security Groups
- Allow inbound traffic:
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)
  - Application port (8081)
  - Kubernetes ports (6443, 2379-2380, 10250-10252)
- Allow all outbound traffic

### 3. EC2 Instances
- Master Node:
  - Instance type: t2.large
  - Ubuntu AMI
  - 2 vCPUs, 8 GB RAM
  - Root volume: 20 GB
  
- Worker Nodes (2):
  - Instance type: t2.medium
  - Ubuntu AMI
  - 2 vCPUs, 4 GB RAM
  - Root volume: 20 GB

### 4. Key Pairs
- Generate key pair for SSH access

## Implementation Steps

1. Create `main.tf`:
```hcl
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "insurance_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "insurance-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.insurance_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "insurance-public-subnet"
  }
}

# Master Node
resource "aws_instance" "master" {
  ami           = var.ubuntu_ami
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.insurance_key.key_name

  vpc_security_group_ids = [aws_security_group.insurance_sg.id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "insurance-master"
    Role = "master"
  }
}

# Worker Nodes
resource "aws_instance" "workers" {
  count         = 2
  ami           = var.ubuntu_ami
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.insurance_key.key_name

  vpc_security_group_ids = [aws_security_group.insurance_sg.id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "insurance-worker-${count.index + 1}"
    Role = "worker"
  }
}
```

2. Create `variables.tf`:
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ubuntu_ami" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 instances"
  type        = string
}
```

3. Create `outputs.tf`:
```hcl
output "master_public_ip" {
  value       = aws_instance.master.public_ip
  description = "Public IP of master node"
}

output "worker_public_ips" {
  value       = aws_instance.workers[*].public_ip
  description = "Public IPs of worker nodes"
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      master_ip = aws_instance.master.public_ip
      worker_ips = aws_instance.workers[*].public_ip
    }
  )
  filename = "../ansible/inventory"
}
```

4. Create `security.tf`:
```hcl
resource "aws_security_group" "insurance_sg" {
  name        = "insurance-sg"
  description = "Security group for insurance project"
  vpc_id      = aws_vpc.insurance_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API server
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # etcd server client API
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubelet API
  ingress {
    from_port   = 10250
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "insurance-sg"
  }
}
```

5. Create inventory template for Ansible:
```ini
[master]
${master_ip}

[workers]
%{ for ip in worker_ips ~}
${ip}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/insurance-key.pem
```

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Plan the infrastructure:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

4. After successful creation, the output will provide:
- Master node public IP
- Worker nodes public IPs
- Automatically generated Ansible inventory file

## Clean Up

To destroy the infrastructure:
```bash
terraform destroy
```

## Notes
- Make sure to update the `ubuntu_ami` variable with the correct AMI ID for your region
- The SSH key pair should be generated before running Terraform
- The Ansible inventory file will be automatically generated in the ansible directory
- All instances will be created in the same subnet for simplicity
- Security group allows required ports for Kubernetes cluster setup
