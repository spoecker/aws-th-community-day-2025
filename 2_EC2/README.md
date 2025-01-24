# EC2 Deployment Guide

This guide explains how to deploy the AWS Community Day 2025 message board application on Amazon EC2. There are two deployment methods available:

## Method 1: CloudFormation Deployment (Recommended)

### Prerequisites

- AWS CLI installed and configured
- AWS account with necessary permissions
- (Optional) ACM certificate for HTTPS

### Quick Deploy

1. **Deploy the Stack**:

```bash
aws cloudformation create-stack \
    --stack-name aws-community-day \
    --template-body file://template.yaml \
    --capabilities CAPABILITY_IAM
```

To enable HTTPS, include the ACM certificate:

```bash
aws cloudformation create-stack \
    --stack-name aws-community-day \
    --template-body file://template.yaml \
    --parameters ParameterKey=ACMCertificate,ParameterValue=arn:aws:acm:region:account:certificate/certificate-id \
    --capabilities CAPABILITY_IAM
```

### Template Features

The CloudFormation template provides:

- VPC with public and private subnets
- Application Load Balancer
- Auto Scaling Group with 2 EC2 instances
- Security Groups for ALB and EC2
- Automatic instance configuration with Docker and Docker Compose
- Optional HTTPS support via ACM certificate

### Stack Resources

- VPC (10.0.0.0/16)
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- Application Load Balancer
- EC2 instances with Amazon Linux 2023
- Security Groups for ALB and EC2
- Auto Scaling Group

### Monitoring

- Health check path: `/health`
- ALB target group with health monitoring
- Auto Scaling Group monitoring

## Method 2: Manual Deployment

### Infrastructure Setup

1. **Create VPC and Subnets**
2. **Create Security Groups**:

```bash
aws ec2 create-security-group \
    --group-name message-board-sg \
    --description "Security group for message board app"
```

[Rest of the manual deployment steps remain the same...]

## Monitoring and Maintenance

### CloudWatch Metrics

The template enables monitoring for:

- ALB metrics
- EC2 instance metrics
- Target group health

### Logs

View EC2 instance logs:

```bash
# Connect to instance
aws ssm start-session --target i-xxxxxxxxxxxxx

# View Docker logs
docker compose logs -f
```

## Troubleshooting

### Common Issues

1. **Instance Not Joining Target Group**

   - Check security groups
   - Verify health check path (/health)
   - Check instance user data logs:

   ```bash
   cat /var/log/cloud-init-output.log
   ```

2. **Application Not Starting**

   - Connect to instance:

   ```bash
   aws ssm start-session --target i-xxxxxxxxxxxxx
   ```

   - Check Docker status:

   ```bash
   docker ps
   docker compose logs
   ```

3. **Load Balancer Issues**

- Verify security group rules
- Check target group health
- Validate listener configuration

## Security Best Practices

1. Enable HTTPS via ACM certificate
2. Restrict security group access
3. Regular security updates
4. Implement proper monitoring

## Updates and Maintenance

### Update Application

```bash
# Connect to instance, would need to assign IAM role to the instance with needed permissions
aws ssm start-session --target i-xxxxxxxxxxxxx

# Update application
cd /home/ec2-user/aws-th-community-day-2025
git pull
docker compose up -d
```

### Update Infrastructure

```bash
# Update CloudFormation stack
aws cloudformation update-stack \
    --stack-name aws-community-day \
    --template-body file://template.yaml
```

## Support

For issues and questions, please contact:

- LinkedIn: <https://www.linkedin.com/in/alexander-spoecker/>
- GitHub Issues: [Create an issue](https://github.com/spoecker/aws-th-community-day-2025/issues)
