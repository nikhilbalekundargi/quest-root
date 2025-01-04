bucket         = "quest-assignment-tf-backend"
key            = "vpc/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "quest_tf_state_lock"
encrypt        = true
role_arn = "arn:aws:iam::904233133644:role/TerraformRoleDev"