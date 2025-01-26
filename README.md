# AWS Community Day Thailand 2025 - Demo Code

This repository contains the demo application used in the session "Starting from a Containerized POC and Applying Best Practices/Well-Architected Framework" at AWS Community Day Thailand 2025.

## Overview

A simple message board application that demonstrates the evolution of a containerized application from local development to AWS deployment, incorporating AWS Well-Architected best practices.

### Link to presentation

Presentation from the Community Day: <https://www.slideshare.net/slideshow/starting-from-a-containerised-poc-and-applying-best-practices-well-architected-framework/275154397>

### Features

- Message board with real-time updates
- PostgreSQL database backend
- SSL/TLS support for database connections
- Environment-aware configuration
- Container health monitoring
- ECS task information display

## Project Structure

```text
.
├── 1_POC/              # Local development with Docker Compose
├── 2_EC2/              # EC2 deployment configuration
├── 3_ECS/              # ECS deployment configuration
├── aws-community/      # Application Code
│   ├── src/            # PHP Application source code
│   ├── docker/         # Docker configuration files for PHP container
│   └── nginx/          # Nginx configuration
```

## Quick Start

### Prerequisites

- Docker and Docker Compose
- AWS CLI (for EC2 and ECS deployments)
- An AWS account (for EC2 and ECS deployments)

### Local Development (1_POC)

1. Clone the repository:

   ```bash
   git clone https://github.com/spoecker/aws-th-community-day-2025.git
   cd aws-community-day-2025/1_POC
   ```

2. Start the application:

   ```bash
   docker compose up -d
   ```

3. Access the application:

   ```text
   http://localhost
   ```

4. Available endpoints:

- `/` - Main message board
- `/crash` - Simulate container crash (for testing)
- `/clear` - Clear all messages

### Database Configuration

The application supports both non-SSL and SSL database connections:

```env
DB_HOST=your-database-host
DB_PORT=5432
DB_DATABASE=myapp
DB_USERNAME=myuser
DB_PASSWORD=mypassword
PGSSLMODE=verify-full  # Optional: Enable SSL
```

## Deployment Options

### EC2 Deployment (2_EC2)

Deploy the application on EC2 instances with:

1. Amazon Linux 2023
2. Docker and Docker Compose

Detailed instructions in the [2_EC2/README.md](2_EC2/README.md)

### ECS Deployment (3_ECS)

Deploy using AWS Elastic Container Service with:

1. Fargate launch type
2. Application Load Balancer
3. RDS PostgreSQL database

Detailed instructions in the [3_ECS/README.md](3_ECS/README.md)

## Container Images

The application consists of two main containers:

- **PHP-FPM**: Application logic and database connectivity
- **Nginx**: Web server and static file serving

## Development

### Rebuilding Containers

```bash
docker compose down
docker compose build
docker compose up -d
```

### Testing

```bash
# Health check
curl http://localhost/health

# Clear messages
curl http://localhost/clear
```

## Security Notes

1. This is a demonstration application and includes features that should not be used in production:

   - `/crash` endpoint for container crash testing
   - `/clear` endpoint without authentication
   - Simplified error handling

2. For production use, consider:
   - Adding authentication
   - Implementing proper logging
   - Setting up monitoring
   - Configuring backup solutions

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Alexander Spoecker  
LinkedIn: <https://www.linkedin.com/in/alexander-spoecker/>
