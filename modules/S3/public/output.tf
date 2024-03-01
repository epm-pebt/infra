output "s3_bucket_public" {
  value = aws_s3_bucket.s3_bucket_public.id
  #   sensitive   = true
  description = "bucket_public"
}
