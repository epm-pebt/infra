output "security_group_ids" {
  description = "List of security group IDs created by the module"
  value       = aws_security_group.Webserver[*].id
}
output "security_group_id" {
  description = "List of security group IDs created by the module"
  value       = aws_security_group.Webserver.id
}