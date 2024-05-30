output "instance_this_id" {
  description = "The id of the EC2 instance"
  value       = module.ec2_instance_webserver.instance_this_id
}

output "bucket_artifact_name" {
  description = "The name of the S3 bucket"
  value       = module.bucket_artifact.bucket_artifact_name
}
