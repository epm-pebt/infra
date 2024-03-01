
#---------------------S3-Public---------------------------------------------
resource "aws_s3_bucket" "s3_bucket_public" {
  bucket = var.bucket_public
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_public" {
  bucket = aws_s3_bucket.s3_bucket_public.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_public" {
  bucket = aws_s3_bucket.s3_bucket_public.id

  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.owners]

}
#----------------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "owners" {
  bucket = aws_s3_bucket.s3_bucket_public.id

  rule { object_ownership = "BucketOwnerPreferred" }
  depends_on = [aws_s3_bucket_public_access_block.access_block]
}
#----------------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.s3_bucket_public.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_bucket_public" {
  bucket = aws_s3_bucket.s3_bucket_public.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3_bucket_public.arn,
          "${aws_s3_bucket.s3_bucket_public.arn}/*",
        ]
      },
      {
        Principal = "*"
        Action    = ["s3:*", ]
        Effect    = "Allow"
        Resource = [
          aws_s3_bucket.s3_bucket_public.arn,
          "${aws_s3_bucket.s3_bucket_public.arn}/*",
        ]
      },

    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.access_block]
}