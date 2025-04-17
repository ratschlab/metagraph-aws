#!/bin/bash
set -euo pipefail
trap 'echo "Error on line $LINENO"; exit 1' ERR

DEFAULT_AMI_ID="ami-0a6d16cc27aa7e3bc"
DEFAULT_EMAIL="test@example.com"

AMI_ID=""
EMAIL=""
INTERACTIVE=false

# Parse CLI args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ami)
      AMI_ID="$2"
      shift 2
      ;;
    --email)
      EMAIL="$2"
      shift 2
      ;;
    --interactive)
      INTERACTIVE=true
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 [--ami default|build|<ami-id>] [--email your@email.com] [--interactive]"
      exit 1
      ;;
  esac
done

# === AMI selection ===
if $INTERACTIVE; then
  echo "Select AMI option:"
  echo "1) Use default AMI (ID: $DEFAULT_AMI_ID)"
  echo "2) Use custom AMI (enter ID manually)"
  echo "3) Build AMI using metagraph-ami.yaml recipe"
  read -p "Enter your choice [1]: " REPLY
  REPLY="${REPLY:-1}"

  case "$REPLY" in
    1)
      AMI_ID="default"
      ;;
    2)
      read -p "Enter your custom AMI ID: " AMI_ID
      if [[ ! "$AMI_ID" =~ ^ami-[a-f0-9]{8,}$ ]]; then
        echo "Invalid AMI ID format."
        exit 1
      fi
      ;;
    3)
      AMI_ID="build"
      ;;
    *)
      echo "Invalid selection. Please enter 1, 2, or 3."
      exit 1
      ;;
  esac
fi

if [[ -z "$AMI_ID" ]]; then
  echo "Warning: AMI not provided, falling back to default."
  AMI_ID="default"
fi

case "$AMI_ID" in
  default)
    AMI_ID="$DEFAULT_AMI_ID"
    echo "Using default AMI: $AMI_ID"
    ;;
  build)
    echo "Deploying AMI builder stack..."
    aws cloudformation deploy \
      --template-file metagraph-ami.yaml \
      --capabilities CAPABILITY_IAM \
      --stack-name MetagraphAmiBuilder

    echo "Waiting for AMI to finish building..."
    AMI_ID=$(aws cloudformation describe-stacks \
      --stack-name MetagraphAmiBuilder \
      --query "Stacks[0].Outputs[?OutputKey=='AmiId'].OutputValue" \
      --output text)

    echo "Using built AMI: $AMI_ID"
    ;;
  ami-*)
    echo "Using custom AMI: $AMI_ID"
    ;;
  *)
    echo "Invalid value for --ami: $AMI_ID"
    exit 1
    ;;
esac

# === Email selection ===
if $INTERACTIVE; then
  read -p "Notification email [${DEFAULT_EMAIL}]: " EMAIL
  EMAIL="${EMAIL:-$DEFAULT_EMAIL}"
fi
if [[ -z "$EMAIL" ]]; then
  echo "Warning: --email not provided, falling back to no notifications."
  EMAIL=$DEFAULT_EMAIL
  exit 1
fi

# === Deploy main stack ===
aws cloudformation deploy \
  --template-file metagraph-stack.yaml \
  --capabilities CAPABILITY_IAM \
  --stack-name MetagraphQuerySystem \
  --parameter-overrides \
    NotificationEmail="$EMAIL" \
    MetagraphAmiId="$AMI_ID"
