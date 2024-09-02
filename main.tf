provider "aws" {
  region  = "us-east-1"
  profile = "KiranSai"
}

# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "codebuild-testing-25992"
    key     = "build/terraform.tfstate"
    region  = "us-east-1"
    profile = "KiranSai"
  }
}

resource "aws_iam_role" "my_role" {
  name = "my_role_codebuild"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "my_policy" {
  name = "my_policy_codebuild"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "s3:*"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.my_role.name
  policy_arn = aws_iam_policy.my_policy.arn
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "25992-s3bucket-codebuild"
}
