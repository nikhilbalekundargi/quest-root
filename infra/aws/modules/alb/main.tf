locals {
  name_prefix = "${var.project}-${terraform.workspace}"
  
  helm_tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-helm-${var.region}"
    }
  )
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", "root"]
      command     = "aws"
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name = "${local.name_prefix}-alb-controller-${var.region}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
            "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:quest-dev-alb-controller-aws-load-balancer-controller"
          }
        }
      }
    ]
  })
  
  tags = local.helm_tags
}

resource "helm_release" "alb_controller" {
  name       = "${local.name_prefix}-alb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.alb_controller_config.namespace
  version    = var.alb_controller_config.chart_version

  values = [
    templatefile("${path.module}/values/alb-controller-values.yaml", {
      cluster_name = var.cluster_name
      role_arn    = aws_iam_role.alb_controller.arn
      region      = var.region
      replicas    = var.alb_controller_config.replicas
      log_level   = var.alb_controller_config.log_level
    })
  ]

  depends_on = [aws_iam_role_policy_attachment.alb_controller]
}

# Add IAM Policy resource
resource "aws_iam_policy" "alb_controller" {
  name = "${local.name_prefix}-alb-controller-${var.region}"
  path = "/"
  policy = jsonencode(jsondecode(file("${path.module}/policies/alb-controller-policy.json")))
  
  tags = local.helm_tags
}

# Add Policy Attachment
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}