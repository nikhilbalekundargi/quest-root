locals {
  name_prefix = "${var.project}-${terraform.workspace}"
  
  cluster_tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-eks-${var.region}"
      "kubernetes.io/cluster/${local.name_prefix}-cluster" = "owned"
    }
  )

  node_group_tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-node-group"
      "kubernetes.io/cluster/${local.name_prefix}-cluster" = "owned"
    }
  )

  iam_role_tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-eks-role"
    }
  )
}

# EKS Cluster Role
resource "aws_iam_role" "cluster" {
  name = "${local.name_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = local.iam_role_tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "${local.name_prefix}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs    = ["0.0.0.0/0"]  # Restrict this in production
  }

  tags = local.cluster_tags

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# Node Group Role
resource "aws_iam_role" "node_group" {
  name = "${local.name_prefix}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = local.iam_role_tags
}

resource "aws_iam_role_policy_attachment" "node_group_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.node_group.name
}

# EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.name_prefix}-node-group"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }

  tags = local.node_group_tags

  depends_on = [aws_iam_role_policy_attachment.node_group_policies]
}

# ECR Repository
resource "aws_ecr_repository" "app" {
  name = "${local.name_prefix}-app"
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.cluster_tags
}