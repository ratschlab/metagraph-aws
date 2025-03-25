#!/bin/bash

INPUT_FILE=${1:-scheduler-test-input.json}

if [ ! -f "$INPUT_FILE" ]; then
  echo "Input file '$INPUT_FILE' not found."
  echo "Usage: $0 [input_file.json]"
  exit 1
fi

STATE_MACHINE_ARN=$(aws cloudformation describe-stacks \
  --stack-name MetagraphQuerySystem \
  --query 'Stacks[0].Outputs[?OutputKey==`StateMachineArn`].OutputValue' \
  --output text)

echo "Starting execution with input file: $INPUT_FILE"

aws stepfunctions start-execution \
  --state-machine-arn "$STATE_MACHINE_ARN" \
  --input "file://$INPUT_FILE"
