output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider" {
  description = "The OpenID Connect provider URL"
  value       = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}