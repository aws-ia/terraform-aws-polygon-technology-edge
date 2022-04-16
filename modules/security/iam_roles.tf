resource "aws_iam_role_policy" "ec2_to_assm" {
  name = "ec2_to_assm"
  role = aws_iam_role.ec2_to_assm.id

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
        Resource = "arn:aws:ssm:eu-central-1:430792124313:parameter/polygon-edge/nodes/*"
      },
      {
        Action =  [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow",
        Resource = ["arn:aws:s3:::polygon-edge-shared/*"]
      },
      {
        Action =  ["s3:ListBucket"]
        Effect = "Allow",
        Resource = ["arn:aws:s3:::polygon-edge-shared"]
      }
    ]
  })

}

resource "aws_iam_role" "ec2_to_assm" {
  name = "ec2_to_assm"

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

resource "aws_iam_instance_profile" "ec2_to_assm" {
    name = "allow_ec2_to_assm"
    role = "ec2_to_assm"
}