data "archive_file" "lambda_transform_zip" {
  type        = "zip"
  source_file = "lambda-transform/main.py"
  output_path = "lambda-transform/lambda.zip"
}

resource "aws_lambda_function" "transform" {
  function_name    = "${local.name}-transform"
  role             = aws_iam_role.lambda.arn
  filename         = data.archive_file.lambda_transform_zip.output_path
  source_code_hash = data.archive_file.lambda_transform_zip.output_base64sha256

  handler = "main.lambda_handler"
  runtime = "python3.11"
  timeout = 60
}

resource "aws_cloudwatch_log_group" "lambda_transform" {
  name              = "/aws/lambda/${aws_lambda_function.transform.function_name}"
  retention_in_days = 1
}

# Lambda permission for Firehose to invoke the function
resource "aws_lambda_permission" "transform_allow_firehose" {
  statement_id  = "AllowFirehoseInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform.function_name
  principal     = "firehose.amazonaws.com"

  # Specify the ARN of the Firehose delivery stream
  source_arn = aws_kinesis_firehose_delivery_stream.lambda_logs.arn
}
