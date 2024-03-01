output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}
output "address_db" {
  description = "endpoint database"
  value       = module.rds.db_instance_endpoint
}
# output "s3_buckets_public" {
#   description = "endpoint database"
#   value       = module.s3_buckets_public.s3_bucket_public
# }
# output "s3_bucket_privat" {
#   description = "s3_bucket_privat"
#   value       = module.s3_buckets_privat.s3_bucket_privat
# }