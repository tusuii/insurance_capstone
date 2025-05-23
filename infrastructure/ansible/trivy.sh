#!/bin/bash

# Install dependencies
apt-get install -y wget apt-transport-https gnupg lsb-release

# Add Trivy repository
mkdir -p /etc/apt/keyrings
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor > /etc/apt/keyrings/trivy.gpg
echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list

# Install Trivy
apt-get update
apt-get install -y trivy