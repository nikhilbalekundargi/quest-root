#ALB
output "alb_controller_role_arn" {
  description = "ALB Controller IAM Role ARN"
  value       = module.helm_resources.alb_controller_role_arn
}

output "alb_controller_status" {
  description = "ALB Controller Installation Status"
  value       = module.helm_resources.alb_controller_status
}