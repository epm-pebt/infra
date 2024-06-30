output "instance_this_id" {
  description = "The id of the EC2 instance"
  value       = module.ec2_instance_webserver.instance_this_id
}

output "bucket_artifact_name" {
  description = "The name of the S3 bucket with artifacts"
  value       = module.bucket_artifact.bucket_name
}

output "bucket_frontend_name" {
  description = "The name of the s3 bucket for frontend deployment"
  value       = module.bucket_frontend.bucket_name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "api_gateway_invoke_url" {
  description = "Invoke URL for API Gateway"
  value       = module.api_gateway.api_gateway_invoke_url
}
