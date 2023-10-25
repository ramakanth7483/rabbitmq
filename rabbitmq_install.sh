#!/bin/bash

# Check if the required dependencies are installed
dependencies=("wget" "curl" "gnupg")
missing_dependencies=()

for dependency in "${dependencies[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        missing_dependencies+=("$dependency")
    fi
done

# Install missing dependencies
if [[ ${#missing_dependencies[@]} -ne 0 ]]; then
    echo "Installing missing dependencies: ${missing_dependencies[*]}"
    sudo apt update
    sudo apt install -y "${missing_dependencies[@]}"
fi

# Download and install Erlang
wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_23.2.3-1~ubuntu~20.04_amd64.deb
sudo apt install -y ./esl-erlang_23.2.3-1~ubuntu~20.04_amd64.deb

# Download and install RabbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
sudo apt install -y rabbitmq-server

# Configure the script to run on server reboot or restart
sudo systemctl enable rabbitmq-server

echo "RabbitMQ and Erlang installation completed successfully!"
