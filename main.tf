provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name = "tf-lambda-firehose-to-s3"
    }
  }

}

data "aws_default_tags" "default" {}

locals {
  name = data.aws_default_tags.default.tags["Name"]
}

data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "lambda/main.py"
  output_path = "lambda/lambda.zip"
}

resource "aws_lambda_function" "default" {
  function_name = local.name
  role          = aws_iam_role.lambda.arn
  filename = data.archive_file.lambda_zip.output_path

  handler = "main.lambda_handler"
  runtime          = "python3.8"
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${aws_lambda_function.default.function_name}"
  retention_in_days = 1
}