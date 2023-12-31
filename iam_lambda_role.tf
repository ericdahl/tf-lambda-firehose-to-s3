data "aws_iam_policy_document" "assume_lambda" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

# custom policy to allow the Transform lambda to get tags for the CW Log Group to propagate into logs
data "aws_iam_policy_document" "logs_get_tags" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:ListTagsForResource",
      "logs:ListTagsLogGroup",
    ]
  }
}

resource "aws_iam_policy" "logs_get_tags" {
  policy = data.aws_iam_policy_document.logs_get_tags.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_get_tags" {
  policy_arn = aws_iam_policy.logs_get_tags.arn
  role       = aws_iam_role.lambda.name
}