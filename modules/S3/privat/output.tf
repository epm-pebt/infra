output "s3_bucket_privat" {
  value = aws_s3_bucket.bucketforartifact.id
  #   sensitive   = true
  description = "bucket_public"
}
