data "aws_iam_policy_document" "assume_cloudwatch" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      values   = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "${local.name}-cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.assume_cloudwatch.json
}

data "aws_iam_policy_document" "firehose_put_record" {
  statement {
    effect  = "Allow"
    actions = ["firehose:PutRecord"]
    resources = [
      aws_kinesis_firehose_delivery_stream.lambda_logs.arn
    ]
  }
}

resource "aws_iam_policy" "firehose_put_record" {
  policy = data.aws_iam_policy_document.firehose_put_record.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_firehose_put_record" {
  policy_arn = aws_iam_policy.firehose_put_record.arn
  role       = aws_iam_role.cloudwatch.name
}