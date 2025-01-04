terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = "root"
}

locals {
  policy_document       = file("${path.module}/../../policies/tf-policy.json")
  trust_policy_document = templatefile("${path.module}/../../policies/trust-policy.json.tftpl", {
    account_id = var.account_id
    user_name  = var.user_name
  })
}

module "iam_role_prod" {
  source                 = "../../modules"
  role_name              = var.role_name
  policy_name            = var.policy_name
  policy_document        = local.policy_document
  trust_policy_document  = local.trust_policy_document
}