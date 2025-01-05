project     = "quest"
environment = "dev"
region      = "ap-south-1"
billing_id  = "quest-dev"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnet_cidrs = ["10.0.32.0/20", "10.0.48.0/20"]

terraform_role_arn = "arn:aws:iam::904233133644:role/TerraformRoleDev"

#ALB
alb_controller_config = {
  namespace      = "kube-system"
  chart_version  = "1.5.3"
  replicas       = 1
  log_level      = "info"
  shield_enable  = false
  wafv2_enable   = false
}