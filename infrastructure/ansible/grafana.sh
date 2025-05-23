#!/bin/bash

# Install dependencies
apt-get install -y apt-transport-https software-properties-common wget

# Add Grafana GPG key and repository
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor > /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list

# Install Grafana
apt-get update
apt-get install -y grafana

# Start Grafana
systemctl enable grafana-server
systemctl start grafana-server