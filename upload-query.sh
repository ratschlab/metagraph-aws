#!/usr/bin/env bash

# Exit immediately on error, treat unset variables as errors,
# and propagate errors in pipelines
set -euo pipefail

# Usage: ./upload_query.sh <full_file_path>
# Example: ./upload_query.sh /path/to/test_query.fasta

STACK_NAME="MetagraphQuerySystem"

# 1. Verify that a file path was provided
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <full_file_path>"
  exit 1
fi

QUERY_FILE="$1"

# 2. Retrieve the bucket name from the CloudFormation stack
BUCKET=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" \
  --output text)

# 3. Extract just the filename from the path
FILE_BASENAME=$(basename "$QUERY_FILE")

# 4. Perform the upload
aws s3 cp "$QUERY_FILE" "s3://$BUCKET/queries/$FILE_BASENAME"
