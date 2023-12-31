data "archive_file" "lambda_hello_zip" {
  type        = "zip"
  source_file = "lambda-hello/main.py"
  output_path = "lambda-hello/lambda.zip"
}

resource "aws_lambda_function" "hello" {
  function_name    = "${local.name}-hello"
  role             = aws_iam_role.lambda.arn
  filename         = data.archive_file.lambda_hello_zip.output_path
  source_code_hash = data.archive_file.lambda_hello_zip.output_base64sha256

  handler = "main.lambda_handler"
  runtime = "python3.11"
}

resource "aws_cloudwatch_log_group" "lambda_hello" {
  name              = "/aws/lambda/${aws_lambda_function.hello.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_event_rule" "cron_minute" {
  name                = "every-minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_lambda_permission" "hello_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_minute.arn
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.cron_minute.name
  target_id = "TargetFunction"
  arn       = aws_lambda_function.hello.arn
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_logs" {
  destination_arn = aws_kinesis_firehose_delivery_stream.lambda_logs.arn
  filter_pattern  = "" # everything
  log_group_name  = aws_cloudwatch_log_group.lambda_hello.name
  name            = local.name

  role_arn = aws_iam_role.cloudwatch.arn
}

