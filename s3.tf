resource "aws_s3_bucket" "data" {
  bucket_prefix = "${var.common_tags.Project}-${var.common_tags.env}"
  tags = {
    Name = "S3 Test Bucket for Signed URLs"
  }
}

