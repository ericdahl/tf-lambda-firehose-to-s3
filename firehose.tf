resource "aws_kinesis_firehose_delivery_stream" "lambda_logs" {
  name        = local.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.lambda_logs.arn


    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.default.name
      log_stream_name = "lambda"

    }
  }

}

resource "aws_cloudwatch_log_group" "kinesis_lambda_logs" {
  name              = "${local.name}-firehose-error-log"
  retention_in_days = 1
}