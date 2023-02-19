terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# The archive provider will expose resources to manage archive files.
provider "archive" {}