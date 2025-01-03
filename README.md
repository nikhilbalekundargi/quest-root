# quest-root

Create Dockerfile using docker init command.

Use IRSA for EKS


 Conditional Logic in Terraform:

 Conditional Resource Creation

 Using dynamic Blocks for Conditional Arguments

 Conditionals in locals


 S3 Bucket Configuration:

Versioning: Enabled to keep track of changes to the state file.
Server-Side Encryption: Enabled with SSE-KMS for encryption control.
Lifecycle Rule: Configured to transition logs to Glacier storage after 30 days.
Bucket Policy: Restricts access to the bucket to specific AWS accounts.
DynamoDB Table Configuration:

Billing Mode: Set to PAY_PER_REQUEST for flexible scaling.
Primary Key: Set to LockID for state locking.


provider "aws" {
  region = var.region
}

locals {
  environment = terraform.workspace
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.medium"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "eks" {
  source = "./eks"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  cluster_name = "quest-cluster-${local.environment}"
  node_group_name = "quest-node-group-${local.environment}"
  desired_capacity = local.environment == "prod" ? 3 : 2
  max_capacity = local.environment == "prod" ? 5 : 3
  min_capacity = 1
  instance_type = local.instance_type
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}


Why workspaces to isolate state files.