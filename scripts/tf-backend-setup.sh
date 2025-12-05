#!/bin/bash
set -e

BUCKET_NAME=$1
TABLE_NAME=$2
AWS_REGION=$3

echo "Checking S3 bucket: $BUCKET_NAME"

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket exists."
else
    echo "Creating bucket..."
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$AWS_REGION" 
fi

echo "Enabling bucket versioning..."
aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

echo "Checking DynamoDB table: $TABLE_NAME"

if aws dynamodb describe-table --table-name "$TABLE_NAME" 2>/dev/null; then
    echo "DynamoDB table exists."
else
    echo "Creating DynamoDB table..."
    aws dynamodb create-table \
      --table-name "$TABLE_NAME" \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST \
      --region "$AWS_REGION"
fi
