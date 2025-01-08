# Terraform Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

# Provider Block
provider "aws" {
  # Configuration options
  region="us-east-2"
}