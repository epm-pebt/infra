
#--------------------S3-Privat--------------------------------------------

resource "aws_s3_bucket" "bucketforartifact" {
  bucket = var.bucket_privat

  tags = {
    Name        = "Artifact-backet"
    Environment = "Dev"
  }
}
#----------------------S3-Polisi---------------------------------------------

#  resource "aws_s3_bucket_policy" "bucketforartifact" {
#      bucket = aws_s3_bucket.bucketforartifact.id

#     policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#         {
#             Effect = "Allow"   
#             Principal = "*"
#             Action = [
#                 "s3:PutObject",
#                 "s3:GetObject",
#                 "s3:DeleteObject",
#                 "s3:ListBucket"
#             ]
#             Resource = [aws_s3_bucket.bucketforartifact.arn, "${aws_s3_bucket.bucketforartifact.arn}/*"]
#         }
#     ]
# })
# }
