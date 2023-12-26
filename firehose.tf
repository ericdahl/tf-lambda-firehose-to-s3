resource "aws_kinesis_firehose_delivery_stream" "lambda_logs" {
  name        = local.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.lambda_logs.arn

  }
}