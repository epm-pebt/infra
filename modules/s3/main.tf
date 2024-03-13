locals {
    bucket_private = var.bucket_private
    bucket_public  = var.bucket_public
}

resource "aws_s3_bucket" "this" {

  bucket        = var.bucket
  bucket_prefix = var.bucket_prefix

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled

  tags = merge(
    { "Name" = var.name },
    var.tags
  )
}  


#---------------------S3-Private---------------------------------------------

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = local.bucket_private ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicAllObject"
        Effect    = "Allow"
        Principal = {
           "Service": "ec2.amazonaws.com"
        }
        Action    = [ 
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [ 
          aws_s3_bucket.this.arn, 
          "${aws_s3_bucket.this.arn}/*" 
        ]
      }
    ]
  })
}


#---------------------S3-Public---------------------------------------------

resource "aws_s3_bucket_website_configuration" "this" {
  count  = local.bucket_public ? 1 : 0
  bucket = aws_s3_bucket.this.id
  
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = local.bucket_public ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  count  = local.bucket_public ? 1 : 0

  bucket = aws_s3_bucket.this.id

  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.this]

}

resource "aws_s3_bucket_ownership_controls" "this" {
  count  = local.bucket_public ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule { object_ownership = "BucketOwnerPreferred" }
  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]
}

resource "aws_s3_bucket_policy" "s3_bucket_public" {
  count  = local.bucket_public ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      },
      {
        Principal = "*"
        Action    = ["s3:*", ]
        Effect    = "Allow"
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      },

    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.this]
}