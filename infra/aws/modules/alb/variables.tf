variable "project" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "EKS OIDC Provider ARN"
}


variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
}

variable "oidc_provider" {
  type        = string
  description = "EKS OIDC Provider URL"
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


variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "EKS cluster CA certificate"
}