# IAM Roles Module Outputs

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.role.name
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.role.arn
}

output "role_id" {
  description = "ID of the IAM role"
  value       = aws_iam_role.role.id
}

output "instance_profile_name" {
  description = "Name of the instance profile (if created)"
  value       = try(aws_iam_instance_profile.profile[0].name, null)
}

output "instance_profile_arn" {
  description = "ARN of the instance profile (if created)"
  value       = try(aws_iam_instance_profile.profile[0].arn, null)
}

output "custom_policy_arn" {
  description = "ARN of the custom policy (if created)"
  value       = try(aws_iam_policy.custom_policy[0].arn, null)
}

