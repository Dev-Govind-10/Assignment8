# Full Stack Application Deployment with Terraform

This project provides two deployment options for a Flask backend + Express frontend application using Terraform on AWS.

## Application Stack
- **Backend**: Flask (Python) API on port 8000
- **Frontend**: Express.js (Node.js) on port 3000

## Deployment Options

### Part 1: EC2 Single Instance
Simple deployment on a single EC2 instance with both services.

**Architecture:**
- Custom VPC with public subnet
- Single EC2 instance (t2.micro)
- PM2 process manager
- Direct instance access

**Use Case:** Development, testing, small applications

### Part 2: ECS Fargate with Load Balancer
Containerized deployment using AWS ECS Fargate with high availability.

**Architecture:**
- Existing VPC infrastructure
- ECR repositories for container images
- ECS Fargate cluster
- Application Load Balancer
- Auto-scaling capabilities

**Use Case:** Production, scalable applications

## Prerequisites
- AWS CLI configured
- Terraform installed
- SSH key pair (Part 1 only)
- Docker (Part 2 only)

## Quick Start

### Part 1 - EC2 Deployment
```bash
cd part1
terraform init
terraform apply
```
Access: `http://<instance-ip>:3000` (frontend), `http://<instance-ip>:8000` (backend)

### Part 2 - ECS Deployment
```bash
cd part2
# Build and push images to ECR first
terraform init
terraform apply
./imagePushScript.sh
```
Access: `http://<alb-dns>:3000` (frontend), `http://<alb-dns>:8000` (backend)

## Configuration

### Part 1 Variables
- `region`: AWS region (default: ap-south-1)
- `ami_id`: Ubuntu AMI ID
- `ssh_public_key`: SSH public key path

### Part 2 Variables
- `aws_region`: AWS region (default: ap-south-1)
- `vpc_id`: Existing VPC ID
- `public_subnet_ids`: Existing subnet IDs
- `desired_count`: Number of tasks (default: 1)

## Cleanup
```bash
terraform destroy
```