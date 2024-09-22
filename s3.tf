resource "aws_s3_bucket" "data" {
  bucket_prefix = "${var.common_tags.Project}-${var.common_tags.env}"
  tags = {
    Name = "S3 Test Bucket for Signed URLs"
  }
}


resource "aws_s3_bucket" "trusty" {
  bucket_prefix = "${var.common_tags.Project}-${var.common_tags.env}-trusty"
  tags = {
    Name = "Bucket for remote accounts to use PutObject"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.trusty.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.trusted_bucket_writers
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.trusty.arn,
      "${aws_s3_bucket.trusty.arn}/*",
    ]
  }
}
