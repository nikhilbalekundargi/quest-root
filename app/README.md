# Quest App Docker Build Guide

## Features
- Multi-stage builds for reducing image size
- Non-root user for security
- Platform-specific builds (amd64/arm64)

## Prerequisites
- AWS CLI configured
- Docker installed
- Access to ECR repository

## Build Instructions

### 1. ECR Login
```bash
aws ecr get-login-password \
    --region ap-south-1 \
    --profile <aws-profile>> | \
    docker login --username AWS \
    --password-stdin 904233133644.dkr.ecr.ap-south-1.amazonaws.com
```

### 2. Build Image

# For Linux/amd64
```bash
docker build -t 904233133644.dkr.ecr.ap-south-1.amazonaws.com/quest-dev-app:latest .
```

# Push docker image
```bash
docker buildx build --platform linux/amd64 --push -t 904233133644.dkr.ecr.ap-south-1.amazonaws.com/quest-dev-app:latest .
```

# Push image to registry
```bash
docker push 904233133644.dkr.ecr.ap-south-1.amazonaws.com/quest-dev-app:latest
```