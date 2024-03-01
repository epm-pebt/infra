provider "aws" {}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-250720241"
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "terrafrom-state"
    Environment = "Dev"
  }
}