resource "aws_iam_role" "tf_role" {
  name               = var.role_name
  assume_role_policy = var.trust_policy_document
}

resource "aws_iam_role_policy" "tf_policy" {
  name   = var.policy_name
  role   = aws_iam_role.this.id
  policy = var.policy_document
}