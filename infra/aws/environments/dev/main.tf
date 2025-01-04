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