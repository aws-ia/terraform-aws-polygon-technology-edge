data "aws_partition" "current" {}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}