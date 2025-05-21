#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_message() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

print_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if ansible is installed
if ! command -v ansible &> /dev/null; then
    print_error "Ansible is not installed. Please install Ansible first."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    print_error "jq is not installed. Please install jq first."
    exit 1
fi

# Set working directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"

# Create ansible directory if it doesn't exist
mkdir -p "${ANSIBLE_DIR}"

# Function to check if tfvars file has SSH key
check_ssh_key() {
    if ! grep -q "ssh_public_key" "${TERRAFORM_DIR}/terraform.tfvars"; then
        print_error "Please add your SSH public key to terraform.tfvars"
        exit 1
    fi
}

# Initialize and apply Terraform configuration
setup_infrastructure() {
    print_message "Initializing Terraform..."
    cd "${TERRAFORM_DIR}"
    
    terraform init
    if [ $? -ne 0 ]; then
        print_error "Terraform initialization failed"
        exit 1
    fi

    print_message "Planning Terraform changes..."
    terraform plan
    if [ $? -ne 0 ]; then
        print_error "Terraform plan failed"
        exit 1
    fi

    print_message "Applying Terraform configuration..."
    terraform apply -auto-approve
    if [ $? -ne 0 ]; then
        print_error "Terraform apply failed"
        exit 1
    fi

    # Export IPs for Ansible
    MASTER_IP=$(terraform output -raw master_public_ip)
    WORKER_IPS=$(terraform output -json worker_public_ips | jq -r '.[]')
    
    print_message "Infrastructure created successfully!"
    print_message "Master IP: ${MASTER_IP}"
    print_message "Worker IPs: ${WORKER_IPS}"
}

# Wait for SSH to become available
wait_for_ssh() {
    local ip=$1
    print_message "Waiting for SSH to become available on ${ip}..."
    
    for i in {1..30}; do
        if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 ubuntu@${ip} 'exit' 2>/dev/null; then
            print_message "SSH is available on ${ip}"
            return 0
        fi
        echo -n "."
        sleep 10
    done
    
    print_error "Timeout waiting for SSH on ${ip}"
    return 1
}

# Run Ansible playbook
run_ansible() {
    print_message "Waiting for all instances to be ready..."
    
    # Wait for SSH on master
    wait_for_ssh "${MASTER_IP}"
    
    # Wait for SSH on workers
    echo "${WORKER_IPS}" | while read -r worker_ip; do
        wait_for_ssh "${worker_ip}"
    done

    print_message "Running Ansible playbook..."
    cd "${SCRIPT_DIR}"
    
    # Copy the ansible playbook to ansible directory if it exists in parent directory
    if [ -f "../star-agile-insurance-project/ansible-playbook.yml" ]; then
        cp "../star-agile-insurance-project/ansible-playbook.yml" "${ANSIBLE_DIR}/"
    fi

    # Run ansible playbook
    ansible-playbook -i "${ANSIBLE_DIR}/inventory" "${ANSIBLE_DIR}/ansible-playbook.yml"
    if [ $? -ne 0 ]; then
        print_error "Ansible playbook execution failed"
        exit 1
    fi
}

# Main execution
main() {
    print_message "Starting infrastructure setup..."
    
    # Check prerequisites
    check_ssh_key
    
    # Setup infrastructure
    setup_infrastructure
    
    # Run Ansible playbook
    run_ansible
    
    print_message "Setup completed successfully!"
    print_message "Jenkins URL: http://${MASTER_IP}:8080"
    print_message "Application URL: http://${MASTER_IP}:8084"
}

# Run main function
main
