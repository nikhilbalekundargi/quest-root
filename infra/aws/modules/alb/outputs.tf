output "alb_controller_role_arn" {
  description = "ARN of IAM role used by ALB controller"
  value       = aws_iam_role.alb_controller.arn
}

output "alb_controller_policy_arn" {
  description = "ARN of IAM policy attached to ALB controller role"
  value       = aws_iam_policy.alb_controller.arn
}

output "alb_controller_namespace" {
  description = "Namespace where ALB controller is installed"
  value       = helm_release.alb_controller.namespace
}

output "alb_controller_status" {
  description = "Status of ALB controller helm release"
  value       = helm_release.alb_controller.status
}