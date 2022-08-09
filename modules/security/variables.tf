variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "internal_sec_gr_name_tag" {
  type        = string
  description = "Internal security group name tag"
}

variable "s3_shared_bucket_name" {
  type        = string
  description = "The name of the S3 bucket that holds shared polygon-edge nodes data"
}

variable "ssm_parameter_id" {
  description = "The id that will be used for storing and fetching from SSM Parameter Store"
  type        = string
}

variable "region" {
  type        = string
  description = "The region in which instances reside. Default: us-west-2"
}

variable "account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "alb_sec_gr_name_tag" {
  type        = string
  description = "The name tag for ALB security group"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the chain initialization Lambda function"
}