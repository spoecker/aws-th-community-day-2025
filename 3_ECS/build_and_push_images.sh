#!/bin/bash

# Set variables
AWS_REGION="ap-southeast-7"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
APP_NAME="aws-community"

# Create ECR repositories if they don't exist
create_repository() {
    local repo_name="$1"
    aws ecr describe-repositories --repository-names "${repo_name}"  --region ${AWS_REGION} 2>/dev/null || \
    aws ecr create-repository --repository-name "${repo_name}"  --region ${AWS_REGION} 
}

create_repository "${APP_NAME}-nginx"
create_repository "${APP_NAME}-php"

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build and push images
AWS_REGION=$AWS_REGION AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID docker compose build
AWS_REGION=$AWS_REGION AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID docker compose push


# Update ECS service
#aws ecs update-service --cluster ${APP_NAME}-cluster \
#    --service ${APP_NAME}-service \
#    --force-new-deployment
#
echo "Deployment completed!"
echo "Repos:"
echo "${APP_NAME}-nginx"
echo "${APP_NAME}-php"