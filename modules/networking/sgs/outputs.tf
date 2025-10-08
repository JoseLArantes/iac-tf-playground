output "sg_name" {
  description = "Name of the base security group"
  value       = aws_security_group.base_security_group.name
}

output "sg_id" {
  description = "ID of the base security group"
  value       = aws_security_group.base_security_group.id
}