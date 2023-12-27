data "aws_iam_policy_document" "assume_firehose" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose" {
  name               = "${local.name}-firehose"
  assume_role_policy = data.aws_iam_policy_document.assume_firehose.json
}

data "aws_iam_policy_document" "firehose_log_s3" {
  statement {
    effect = "Allow"

    resources = ["${aws_s3_bucket.lambda_logs.arn}/*"]
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
  }

  statement {
    effect = "Allow"

    resources = [aws_s3_bucket.lambda_logs.arn]
    actions = [
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]
    actions = [
      "logs:putLogEvents"
    ]
  }
}

resource "aws_iam_policy" "firehose_log_s3" {
  policy = data.aws_iam_policy_document.firehose_log_s3.json
}

resource "aws_iam_role_policy_attachment" "firehose_log_s3" {
  policy_arn = aws_iam_policy.firehose_log_s3.arn
  role       = aws_iam_role.firehose.name
}