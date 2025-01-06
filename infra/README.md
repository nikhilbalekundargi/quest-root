# Infrastructure as Code (IaC) with Terraform

## Overview
This directory contains Terraform code for managing AWS infrastructure. It includes modules for reusable components, environment-specific configurations, and IAM roles.

## Directory Structure

infra/ 
├── aws/ 
│ ├── environments/ 
│ │ ├── dev/ 
│ │ │ ├── .terraform/ 
│ │ │ ├── .terraform.lock.hcl 
│ │ │ ├── backend.hcl 
│ │ │ ├── dev.auto.tfvars 
│ │ │ ├── main.tf 
│ │ │ ├── outputs.tf 
│ │ │ └── variables.tf 
│ │ ├── prod/ 
│ │ │ ├── backend.hcl 
│ │ │ └── ... 
│ ├── modules/ 
│ │ ├── alb/ 
│ │ ├── eks/ 
│ │ └── vpc/ 
├── backend/ 
│ ├── .terraform/ 
│ ├── .terraform.lock.hcl 
│ ├── outputs.tf 
│ ├── s3-dynamodb.tf 
│ ├── terraform.tfstate 
│ ├── terraform.tfstate.backup 
│ ├── terraform.tfvars 
│ └── variables.tf 
├── iam-role/ 
│ ├── main/ 
│ │ ├── dev/ 
│ │ ├── prod/ 
│ ├── modules/ 
│ │ ├── main.tf 
│ │ ├── outputs.tf 
│ │ └── variables.tf 
│ └── policies/ 
│ ├── tf-policy.json 
│ └── trust-policy.json.tftpl



## Modules
Reusable Terraform modules for common infrastructure components:
- `alb/`: Application Load Balancer
- `eks/`: Elastic Kubernetes Service
- `vpc/`: Virtual Private Cloud

## Environments
Environment-specific configurations for different stages:
- `dev/`: Development environment
- `prod/`: Production environment

## Workspaces
Terraform workspaces are used to manage multiple environments within the same configuration. Each environment (e.g., dev, prod) has its own workspace.

## Naming Conventions
- **Resources**: Follow the pattern `${project}-${environment}-${resource}`
- **Tags**: Common tags include `Project`, `Environment`, `Region`, `ManagedBy`

## Backend Configuration
State files are stored remotely in an S3 bucket with DynamoDB for state locking.

### Example `backend.hcl`
```hcl
bucket         = "quest-assignment-tf-backend"
key            = "vpc/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "quest_tf_state_lock"
encrypt        = true
role_arn       = "arn:aws:iam::904233133644:role/TerraformRoleDev"
```

## Getting Started
# Initialize Terraform
```bash
cd infra/aws/environments/dev
terraform init

Apply Configuration
terraform apply

Destroy Infrastructure
terraform destroy

IAM Roles
IAM roles are managed separately to ensure least privilege and secure access.
```

```hcl
Example iam-role/main.tf
module "iam_role_dev" {
  source                 = "../../modules"
  role_name              = var.role_name
  policy_name            = var.policy_name
  policy_document        = local.policy_document
  trust_policy_document  = local.trust_policy_document
}
```


## Policies
# IAM policies are defined in JSON files and templated for flexibility.


Example `trust-policy.json.tftpl`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${account_id}:user/${user_name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

## Outputs
#  Outputs are defined to expose useful information such as ARNs, endpoints, and IDs.

Example `outputs.tf`

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}
```json
```


# Setup Instructions

## Step 1: Run Backend Code
Navigate to the `backend` folder and execute the Terraform code. This will create an S3 bucket and DynamoDB table for storing state files remotely and securely.

```bash
cd infra/backend
terraform init
terraform apply
```


## Step 2: Run IAM Role Code
Navigate to the `iam-role` folder and execute the Terraform code. This will create IAM roles for the Terraform user, which are required to create resources using Terraform.


```bash
cd infra/iam-role/main/dev
terraform init
terraform apply
```


## Step 3: Run Infrastructure Code
Navigate to the infra folder and execute the Terraform code. The infra folder contains modules for AWS resources and environments for environment-specific configurations.

```bash
cd infra/aws/environments/dev
terraform init
terraform workspace new dev
terraform apply
```

# Using Terraform Workspaces
Terraform workspaces are used to manage infrastructure for different environments.

```bash
# List existing workspaces
terraform workspace list

# Create a new workspace
terraform workspace new <workspace-name>

# Select an existing workspace
terraform workspace select <workspace-name>
```