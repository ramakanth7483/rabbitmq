#!/bin/bash

# Update package lists
apt update -y

# Install software required for Ansible
apt install -y python3-pip

# Install Ansible using pip
pip3 install ansible

# Download Ansible playbooks from S3 (replace with your bucket and path)
aws s3 cp s3://your-bucket/rabbitmq_install.yml /tmp/rabbitmq_install.yml
aws s3 cp s3://your-bucket/rabbitmq_cluster.yml /tmp/rabbitmq_cluster.yml

# Ensure proper permissions for downloaded playbooks (optional, adjust based on your needs)
chmod 600 /tmp/rabbitmq_install.yml /tmp/rabbitmq_cluster.yml

# Run Ansible playbooks sequentially
ansible-playbook /tmp/rabbitmq_install.yml
ansible-playbook /tmp/rabbitmq_cluster.yml

# Clean up temporary files
rm -f /tmp/rabbitmq_install.yml /tmp/rabbitmq_cluster.yml
