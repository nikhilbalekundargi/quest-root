bucket         = "quest-assignment-tf-backend"
key            = "iam-role/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "quest_tf_state_lock"
encrypt        = true
profile        = "root"