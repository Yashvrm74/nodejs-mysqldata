terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["/Users/yash/.aws/credentials"]
  profile = "terraform-vscode"
}