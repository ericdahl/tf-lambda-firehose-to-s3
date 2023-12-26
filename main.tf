provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name = "tf-lambda-firehose-to-s3"
    }
  }

}
data "aws_caller_identity" "current" {}

data "aws_default_tags" "default" {}

locals {
  name = data.aws_default_tags.default.tags["Name"]
}

