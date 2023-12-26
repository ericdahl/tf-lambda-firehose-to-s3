resource "aws_s3_bucket" "lambda_logs" {
  force_destroy = true
}