resource "aws_lambda_function" "lambda_signed_url" {
  filename         = "./scripts/presigned_url.zip"
  function_name    = "create_presigned_url"
  handler          = "presigned_url.create_presigned_url"
  role             = aws_iam_role.lambda_signed_url_function.arn
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("./scripts/presigned_url.zip")
}

resource "aws_lambda_function_url" "signed_url" {
  function_name      = aws_lambda_function.lambda_signed_url.arn
  authorization_type = "NONE"
}

output "function_url" {
  description = "Signed URL URL"
  value       = aws_lambda_function_url.signed_url
}
