data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda/main.py"
  output_path = "lambda/lambda.zip"
}

resource "aws_lambda_function" "default" {
  function_name    = local.name
  role             = aws_iam_role.lambda.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "main.lambda_handler"
  runtime = "python3.8"
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${aws_lambda_function.default.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_event_rule" "cron_minute" {
  name                = "every-minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_minute.arn
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.cron_minute.name
  target_id = "TargetFunction"
  arn       = aws_lambda_function.default.arn
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_logs" {
  destination_arn = aws_kinesis_firehose_delivery_stream.lambda_logs.arn
  filter_pattern  = "" # everything
  log_group_name  = aws_cloudwatch_log_group.default.name
  name            = local.name

  role_arn = aws_iam_role.cloudwatch.arn
}

