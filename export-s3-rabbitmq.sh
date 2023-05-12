#!/bin/bash

# Set the necessary variables
RABBITMQ_USER="admin"
RABBITMQ_PASS="Ankur@51206"
RABBITMQ_HOST="rabbit@ip-172-31-18-216.ec2.internal"
RABBITMQ_PORT="5672"
S3_BUCKET="rabbitankur"
BACKUP_NAME="rabbitmq_backup_$(date +%Y%m%d%H%M%S).json"
BACKUP_PATH="/tmp/${BACKUP_NAME}"

# Export the RabbitMQ definitions to a backup file
rabbitmqctl export_definitions "${BACKUP_PATH}"

# Check if the backup file exists
if [ -f "${BACKUP_PATH}" ]; then
  echo "RabbitMQ backup created successfully at ${BACKUP_PATH}"

  # Upload the backup file to S3
  aws s3 cp "${BACKUP_PATH}" "s3://${S3_BUCKET}/${BACKUP_NAME}"
  if [ $? -eq 0 ]; then
    echo "Backup uploaded to S3 bucket successfully"
  else
    echo "Failed to upload backup to S3 bucket"
    exit 1
  fi

  # Remove the local backup file
  rm "${BACKUP_PATH}"
  echo "Local backup file removed"
else
  echo "Failed to create RabbitMQ backup"
  exit 1
fi

# Exit the script
exit 0
