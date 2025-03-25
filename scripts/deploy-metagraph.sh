#!/bin/bash

if [ -z "$1" ]; then
  echo "No email provided. Using default: test@example.com"
  EMAIL="test@example.com"
else
  EMAIL="$1"
fi

# Deploy CloudFormation stack with the provided or default email
aws cloudformation deploy \
  --template-file metagraph-stack.yaml \
  --capabilities CAPABILITY_IAM \
  --stack-name MetagraphQuerySystem \
  --parameter-overrides NotificationEmail="$EMAIL"
