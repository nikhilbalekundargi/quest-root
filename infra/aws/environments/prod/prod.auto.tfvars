project        = "quest"
environment    = "prod"
region         = "ap-south-1"
billing_id     = "quest-prod"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["ap-south-1a"]
public_subnet_cidrs  = ["10.0.0.0/20"]
private_subnet_cidrs = ["10.0.32.0/20", "10.0.48.0/20"]

terraform_role_arn   = "arn:aws:iam::PROD_ACCOUNT_ID:role/TerraformRoleProd"