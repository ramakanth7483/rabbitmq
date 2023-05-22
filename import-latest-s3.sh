#!/bin/bash

# RabbitMQ Configuration
RABBITMQ_HOST="44.203.60.107"
RABBITMQ_PORT="15672"
RABBITMQ_USER="admin"
RABBITMQ_PASS="Ankur@51206"

# S3 Configuration
S3_BUCKET="rabbitankur" # Add bucket name
LOCAL_FILE_PATH="/tmp/rabbitmq_data.json"

# Get the latest backup file from S3
echo "Retrieving the latest backup file from S3..."
LATEST_OBJECT_KEY=$(aws s3api list-objects-v2 --bucket "${S3_BUCKET}" --query 'sort_by(Contents, &LastModified)[-1].Key' --output text)

# Check if the latest file exists
if [ -z "$LATEST_OBJECT_KEY" ]; then
  echo "No backup file found in S3. Exiting..."
  exit 1
fi

# Download the latest backup file from S3
echo "Downloading the latest backup file from S3..."
aws s3 cp "s3://${S3_BUCKET}/${LATEST_OBJECT_KEY}" "${LOCAL_FILE_PATH}"

# Import the data into RabbitMQ
echo "Importing data into RabbitMQ..."
rabbitmqadmin -H "${RABBITMQ_HOST}" -P "${RABBITMQ_PORT}" -u "${RABBITMQ_USER}" -p "${RABBITMQ_PASS}" import "${LOCAL_FILE_PATH}"

# Clean up the local file
echo "Cleaning up..."
rm "${LOCAL_FILE_PATH}"

echo "Data import completed!"
