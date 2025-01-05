variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "billing_id" {
  description = "Billing ID for cost tracking"
  type        = string
}

variable "terraform_role_arn" {
  description = "ARN of the IAM role to assume"
  type        = string
}


variable "alb_controller_config" {
  type = object({
    namespace      = string
    chart_version  = string
    replicas       = number
    log_level      = string
    shield_enable  = bool
    wafv2_enable   = bool
  })
  description = "ALB Controller configuration"
}