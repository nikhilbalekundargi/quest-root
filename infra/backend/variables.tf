variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "billing_id" {
  description = "Billing ID"
  type        = string
}

locals {
  common_tags = {
    Environment = var.environment
    billing_id  = var.billing_id
    region      = var.region
  }
}