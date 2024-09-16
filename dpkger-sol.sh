#!/bin/bash

# Check for any running processes that may interfere
if ps aux | grep -i apt-get | grep -v grep; then
    echo "Terminating conflicting apt-get process..."
    conflicting_pid=$(ps aux | grep -i apt-get | grep -v grep | awk '{print $2}')
    sudo kill -9 "$conflicting_pid"
fi

# Attempt to install Erlang and RabbitMQ
if sudo apt-get install -y erlang rabbitmq-server; then
    echo "Erlang and RabbitMQ installed successfully."
else
    error_message=$(sudo apt-get install -y erlang rabbitmq-server 2>&1)
    if [[ $error_message == *"being used by another process"* ]]; then
        # Extract the PID causing the conflict
        conflicting_pid=$(echo "$error_message" | grep -oE '[0-9]+' | head -1)
        echo "A conflicting process is using the package manager. Terminating PID $conflicting_pid..."
        sudo kill -9 "$conflicting_pid"
        # Retry the installation
        sudo apt-get install -y erlang rabbitmq-server
        echo "Erlang and RabbitMQ installed successfully."
    else
        echo "Error: $error_message"
    fi
fi