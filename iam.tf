data "aws_iam_policy_document" "lambda_function_signed_url" {
  statement {
    sid    = "AllowS3Upload"
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [aws_s3_bucket.data.arn, "${aws_s3_bucket.data.arn}/*"]
  }
  statement {
    sid    = "WriteToLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_function_signed_url" {
  name        = "LambdaSignedURLPolicy"
  description = "Lamba Signed URL Policy"
  policy      = data.aws_iam_policy_document.lambda_function_signed_url.json
}


resource "aws_iam_role" "lambda_signed_url_function" {
  name               = "lambda_signed_url_function"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_signed_url_function.name
  policy_arn = aws_iam_policy.lambda_function_signed_url.arn
}
