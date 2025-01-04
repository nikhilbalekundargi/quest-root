terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = var.terraform_role_arn
  }
}

locals {
  workspace_name = terraform.workspace
  common_tags = {
    Environment = local.workspace_name
    Project     = var.project
    Region      = var.region
    billing_id  = var.billing_id
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project              = var.project
  environment          = var.environment
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  project            = var.project
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  common_tags        = local.common_tags

  kubernetes_version = "1.28"
  instance_type      = "t3.medium"
  desired_nodes      = 2
  min_nodes          = 1
  max_nodes          = 2
}