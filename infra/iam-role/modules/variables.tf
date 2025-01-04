variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "policy_document" {
  description = "The policy document"
  type        = string
}

variable "trust_policy_document" {
  description = "The trust policy document"
  type        = string
}