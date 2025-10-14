# Elastic Beanstalk Module Outputs

output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.name
}

output "application_arn" {
  description = "ARN of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.arn
}

output "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.name
}

output "environment_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.id
}

output "environment_cname" {
  description = "CNAME of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.cname
}

output "environment_endpoint_url" {
  description = "Fully qualified DNS name for the environment"
  value       = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "load_balancers" {
  description = "List of load balancers associated with the environment"
  value       = aws_elastic_beanstalk_environment.env.load_balancers
}

output "ec2_role_name" {
  description = "Name of the EC2 IAM role"
  value       = module.eb_ec2_role.role_name
}

output "ec2_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = module.eb_ec2_role.role_arn
}

output "service_role_name" {
  description = "Name of the Elastic Beanstalk service role"
  value       = module.eb_service_role.role_name
}

output "service_role_arn" {
  description = "ARN of the Elastic Beanstalk service role"
  value       = module.eb_service_role.role_arn
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = module.eb_ec2_role.instance_profile_name
}

output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = module.eb_ec2_role.instance_profile_arn
}

