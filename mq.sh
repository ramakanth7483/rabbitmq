#!/bin/bash

# Update the package list and install prerequisites
sudo apt update
sudo apt install -y wget gnupg

# Add the Erlang Solutions repository and the RabbitMQ repository to your sources list
echo "deb http://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang.list
wget -O - https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
echo "deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O - https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key | sudo apt-key add -

# Update the package list again
sudo apt update

# Install Erlang and RabbitMQ
sudo apt install -y erlang rabbitmq-server

# Enable and start the RabbitMQ service
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# Set up RabbitMQ to start on boot
sudo systemctl enable rabbitmq-server