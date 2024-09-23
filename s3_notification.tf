data "aws_iam_policy_document" "topic" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.trusty.arn]
    }
  }
}
resource "aws_sns_topic" "trusty" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.topic.json
}

resource "aws_s3_bucket_notification" "trusty" {
  bucket = aws_s3_bucket.trusty.id

  topic {
    topic_arn = aws_sns_topic.trusty.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
