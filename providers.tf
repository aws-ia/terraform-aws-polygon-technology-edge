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
  }
}

provider "awscc" {
  user_agent = [{
    product_name    = "terraform-polygon-technology-edge"
    product_version = "0.0.1"
    comment         = "V1/AWS-D69B4015/478186123"
  }]
  region = var.region
}

provider "aws" {
  region = var.region
}
