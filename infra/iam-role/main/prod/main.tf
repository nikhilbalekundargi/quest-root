terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "root"
}

locals {
  policy_document       = file("tf-policy.json")
  trust_policy_document = file("trust-policy.json")
}

module "iam_role_dev" {
  source                 = "../../modules"
  role_name              = var.role_name
  policy_name            = var.policy_name
  policy_document        = local.policy_document
  trust_policy_document  = local.trust_policy_document
}