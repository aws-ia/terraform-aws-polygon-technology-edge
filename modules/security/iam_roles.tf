resource "aws_iam_role_policy" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"
  role        = aws_iam_role.polygon_edge_node.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:PutParameter",
          "ssm:DeleteParameter",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = format("arn:aws:ssm:%s:%s:parameter/%s/*", var.region, var.account_id, var.ssm_parameter_id)
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow",
        Resource = [format("arn:aws:s3:::%s/*", var.s3_shared_bucket_name)]
      },
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow",
        Resource = [format("arn:aws:s3:::%s", var.s3_shared_bucket_name)]
      },
      {
        Action   = ["lambda:InvokeFunction"]
        Effect   = "Allow"
        Resource = format("arn:aws:lambda:%s:%s:function:%s", var.region, var.account_id, var.lambda_function_name)
      },
    ]
  })
}

resource "aws_iam_role" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attach" {
  role       = aws_iam_role.polygon_edge_node.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_instance_profile" "polygon_edge_node" {
  name_prefix = "polygon-edge-node-"
  role        = aws_iam_role.polygon_edge_node.name
}