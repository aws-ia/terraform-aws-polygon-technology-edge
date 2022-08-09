terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.27.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}

