data "null_data_source" "downloaded_package" {
  inputs = {
    id       = null_resource.download_package.id
    filename = local.downloaded
  }
}

data "aws_availability_zones" "current" {
  exclude_names = ["us-east-1e", "us-east-1-bos-1a", "us-east-1-atl-1a"]  
  }
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "genesis_s3" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      module.s3.s3_bucket_arn,
      "${module.s3.s3_bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "genesis_ssm" {
  version = "2012-10-17"
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.ssm_parameter_id}/*"
    ]

  }
}
