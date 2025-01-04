output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.tf_role.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.tf_role.name
}