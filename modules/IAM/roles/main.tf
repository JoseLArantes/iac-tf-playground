# IAM Roles Module
# Creates IAM roles with assume role policies and policy attachments

resource "aws_iam_role" "role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = var.assume_role_policy

  tags = merge(var.tags, {
    Name = var.role_name
  })
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_policy" "custom_policy" {
  count = var.custom_policy_json != "" ? 1 : 0

  name        = "${var.role_name}-custom-policy"
  description = "Custom policy for ${var.role_name}"
  policy      = var.custom_policy_json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "custom_policy" {
  count = var.custom_policy_json != "" ? 1 : 0

  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.custom_policy[0].arn
}

resource "aws_iam_instance_profile" "profile" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.role_name}-profile"
  role = aws_iam_role.role.name

  tags = var.tags
}

