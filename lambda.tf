resource "aws_lambda_function" "lambda_signed_url" {
  filename         = "./scripts/presigned_url.zip"
  function_name    = var.lambda_function_name
  runtime          = "python3.11"
  handler          = "presigned_url.create_presigned_url"
  role             = aws_iam_role.lambda_signed_url_function.arn
  source_code_hash = filebase64sha256("./scripts/presigned_url.zip")
  memory_size      = 256
  logging_config {
    log_format = "Text"
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_signed_url,
  ]
}

resource "aws_lambda_function_url" "signed_url" {
  function_name      = aws_lambda_function.lambda_signed_url.arn
  authorization_type = "NONE"
}

output "function_url" {
  description = "Signed URL URL"
  value       = aws_lambda_function_url.signed_url
}

variable "lambda_function_name" {
  default = "create_presigned_url"
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda_signed_url" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_signed_url_function.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
