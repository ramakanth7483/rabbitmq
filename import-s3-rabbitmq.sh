#!/bin/bash

# RabbitMQ Configuration
RABBITMQ_HOST="44.203.60.107"
RABBITMQ_PORT="15672"
RABBITMQ_USER="admin"
RABBITMQ_PASS="Ankur@51206"

# S3 Configuration
S3_BUCKET="rabbitankur" # Add bucket name
S3_OBJECT_KEY="rabbitmq_backup_20230512093718.json" # add file of backup
LOCAL_FILE_PATH="/tmp/restored_data.json"

# Download the data from S3
echo "Downloading data from S3..."
aws s3 cp s3://${S3_BUCKET}/${S3_OBJECT_KEY} ${LOCAL_FILE_PATH}

# Import the data into RabbitMQ
echo "Importing data into RabbitMQ..."
rabbitmqadmin -H ${RABBITMQ_HOST} -P ${RABBITMQ_PORT} -u ${RABBITMQ_USER} -p ${RABBITMQ_PASS} import ${LOCAL_FILE_PATH}

# Clean up the local file
echo "Cleaning up..."
rm ${LOCAL_FILE_PATH}

echo "Data import completed!"
