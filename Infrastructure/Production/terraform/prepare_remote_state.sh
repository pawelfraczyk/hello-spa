#!/bin/bash

# Print trace
set -x -o errexit

#After setting up the bucket and DynamoDb make sure that the same variables are used in provider.tf
REGION="eu-central-1"
BUCKET_NAME=spa-prod-infrastructure
LOCKS_TABLE=spa-prod-tf-locks

aws dynamodb create-table \
    --region $REGION \
    --table-name ${LOCKS_TABLE} \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

aws s3api create-bucket \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION \
    --bucket ${BUCKET_NAME}

aws s3api put-bucket-versioning \
    --region $REGION \
    --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled
