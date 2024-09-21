provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.common_tags
  }
}


terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}
