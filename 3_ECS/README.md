# ECS Deployment Guide

This guide explains how to deploy the AWS Community Day 2025 message board application on Amazon ECS using Fargate.

## Prerequisites

- AWS CLI configured
- Docker installed locally
- Access to an AWS account with necessary permissions

## Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/spoecker/aws-th-community-day-2025.git
```

### 2. Build and Push Docker Images

Run the provided script to create ECR repositories and push images:

```bash
# Make script executable
chmod +x build_and_push_images.sh

# Run script
./build_and_push_images.sh
```

The script will:

- Create ECR repositories for nginx and php images
- Build images using docker-compose
- Push images to ECR

### 3. Deploy CloudFormation Stack

Deploy the infrastructure using the provided template:

```bash
aws cloudformation create-stack \
    --stack-name aws-community \
    --template-body file://template.yaml \
    --parameters \
        ParameterKey=RDSMasterUserName,ParameterValue=demoUserName \
        ParameterKey=RDSMasterUserPassword,ParameterValue=yourSecurePassword \
        ParameterKey=ImagePHP,ParameterValue=aws-community-php \
        ParameterKey=ImageNGINX,ParameterValue=aws-community-nginx \
    --capabilities CAPABILITY_NAMED_IAM
```

For HTTPS support, include the ACM certificate:

```bash
aws cloudformation create-stack \
    --stack-name aws-community \
    --template-body file://template.yaml \
    --parameters \
        ParameterKey=ACMCertificate,ParameterValue=arn:aws:acm:region:account:certificate/id \
        ... [other parameters]
    --capabilities CAPABILITY_NAMED_IAM
```

## Infrastructure Components

The CloudFormation template creates:

### Networking

- VPC (10.0.0.0/16)
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- NAT Gateway
- Required Route Tables

### Database

- RDS PostgreSQL 17.2 instance
- DB Parameter Group with SSL enforcement
- Private subnet placement
- Security group for database access

### Container Infrastructure

- ECS Cluster with Fargate support
- Task Definition for PHP and Nginx containers
- ECS Service with 2 desired tasks
- Application Load Balancer
- Target Group with health checks

### Security

- Security Groups for ALB, ECS, and RDS
- IAM roles for task execution
- SSL configuration for RDS

### Monitoring

- CloudWatch Log Group (7-day retention)
- Container health checks
- ALB health checks

## Environment Variables

The task definition includes the following environment variables for the PHP container:

```env
DB_HOST=<RDS-Endpoint>
DB_PORT=5432
DB_DATABASE=postgres
DB_USERNAME=<from-parameter>
DB_PASSWORD=<from-parameter>
PGSSLMODE=verify-full
TZ=Asia/Bangkok
```

## Monitoring and Logs

View container logs:

```bash
aws logs get-log-events \
    --log-group-name /ecs/aws-community \
    --log-stream-name aws-community/php/<task-id>
```

Check service status:

```bash
aws ecs describe-services \
    --cluster aws-community \
    --services aws-community-demo-service
```

## Troubleshooting

### Common Issues

1. **Task Not Starting**

   ```bash
   # Check task status
   aws ecs describe-tasks \
       --cluster aws-community \
       --tasks <task-id>

   # View logs
   aws logs tail /ecs/aws-community
   ```

2. **Database Connection Issues**

   - Verify security group rules
   - Check SSL mode configuration
   - Validate credentials

3. **Health Check Failures**

   - Verify `/health` endpoint is responding
   - Check container logs for PHP errors
   - Verify network connectivity

## Cleanup

To remove all resources:

```bash
aws cloudformation delete-stack --stack-name aws-community
```

## Support

For issues and questions, please contact:

- LinkedIn: <https://www.linkedin.com/in/alexander-spoecker/>
- GitHub Issues: [Create an issue](https://github.com/yourusername/aws-th-community-day-2025/issues)
