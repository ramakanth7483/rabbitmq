#!/bin/bash

# Install prerequisites
sudo apt-get update
sudo apt-get install wget apt-transport-https -y

# Add RabbitMQ repository key
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -

# Add RabbitMQ repository
echo "deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang-22.x" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

# Install RabbitMQ server
sudo apt-get update
sudo apt-get install rabbitmq-server -y --fix-missing

# Enable RabbitMQ management plugin
sudo rabbitmq-plugins enable rabbitmq_management

# Set user password for RabbitMQ management console
read -sp "Enter password for RabbitMQ management console: " password
echo ""
sudo rabbitmqctl add_user admin "$password"
sudo rabbitmqctl set_user_tags admin administrator

# Restart RabbitMQ server
sudo systemctl restart rabbitmq-server

# Display RabbitMQ status
sudo systemctl status rabbitmq-server
