locals {
  name_prefix = "${var.project}-${terraform.workspace}"
  is_prod     = terraform.workspace == "prod"

  vpc_tags = merge(
    var.common_tags,
    {
      Name        = "${local.name_prefix}-vpc-${var.region}"
      Environment = terraform.workspace
      ManagedBy   = "terraform"
    }
  )

  eks_tags = {
    "kubernetes.io/cluster/${local.name_prefix}-cluster" = "shared"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.vpc_tags,
    {
      Name = "${local.name_prefix}-vpc-${var.region}"
    }
  )
}

resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    local.eks_tags,
    {
      Name                     = "${local.name_prefix}-public-subnet-${var.availability_zones[count.index]}"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    local.eks_tags,
    {
      Name                              = "${local.name_prefix}-private-subnet-${var.availability_zones[count.index]}"
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-igw-${var.region}"
    }
  )
}

resource "aws_eip" "nat" {
  count  = 1 #length(var.availability_zones)
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip-${var.region}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = 1
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-nat-${var.region}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-rt-${var.region}"
    }
  )
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-rt-${var.availability_zones[count.index]}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}