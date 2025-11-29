output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_tls.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.allow_tls.name
}