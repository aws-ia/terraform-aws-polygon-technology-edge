resource "aws_s3_bucket" "nodes_shared_data" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name_tag
  }
}

resource "aws_s3_bucket_acl" "nodes_bucket_acl" {
  bucket = aws_s3_bucket.nodes_shared_data.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "nodes_allow" {
  bucket = aws_s3_bucket.nodes_shared_data.id

  policy = jsonencode({
  "Version": "2012-10-17",
  "Id": "Nodes Allow"
  "Statement": [
    {
      "Sid":    "Nodes Allow"
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
          aws_s3_bucket.nodes_shared_data.arn
          ],
      "Condition": {
        "StringEquals" : {
          "aws:SourceVpce":[
          "${var.vpc_id}"
          ]
        }
      }
    }
  ]
})
}