locals {
  sg_name_prefix = "${local.name_prefix}-sg"
  
  sg_tags = merge(
    var.common_tags,
    {
      "kubernetes.io/cluster/${local.name_prefix}-cluster" = "owned"
    }
  )
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${local.sg_name_prefix}-alb-${var.region}"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.sg_tags,
    {
      Name = "${local.sg_name_prefix}-alb-${var.region}"
    }
  )
}

# EKS Cluster Security Group
resource "aws_security_group" "cluster" {
  name        = "${local.sg_name_prefix}-cluster-${var.region}"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.sg_tags,
    {
      Name = "${local.sg_name_prefix}-cluster-${var.region}"
    }
  )
}

# Node Group Security Group
resource "aws_security_group" "node_group" {
  name        = "${local.sg_name_prefix}-node-group-${var.region}"
  description = "Security group for EKS node groups"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow cluster"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.cluster.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.sg_tags,
    {
      Name = "${local.sg_name_prefix}-node-group-${var.region}"
    }
  )
}
