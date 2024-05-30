output "instance_public_ip" {
  description = "The public ip of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_this_id" {
  description = "The id of the EC2 instance"
  value       = aws_instance.this.id
}
