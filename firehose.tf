resource "aws_kinesis_firehose_delivery_stream" "lambda_logs" {
  name        = local.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.lambda_logs.arn
    prefix     = "logs/lambda/${aws_lambda_function.hello.function_name}/"

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.transform.arn}:$LATEST"
        }

        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "1"
        }

        # https://github.com/hashicorp/terraform-provider-aws/issues/9827
        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "65"
        }
      }
    }

    compression_format = "GZIP"

    buffering_interval = 60

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.lambda_hello.name
      log_stream_name = "lambda"
    }
  }
}

resource "aws_cloudwatch_log_group" "kinesis_lambda_logs" {
  name              = "${local.name}-firehose-error-log"
  retention_in_days = 1
}