output "bucket_domain_name" {
  description = "The DNS domain name of the S3 bucket or custom origin."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket" {
  description = "A unique identifier for the origin."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}
