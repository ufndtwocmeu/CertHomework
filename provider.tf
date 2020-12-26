terraform {
  required_providers {
    aws = {
      version = "3.22.0"
    }
  }
}



# Configure the AWS Provider
provider "aws" {
  region = var.deploy_region
  access_key = var.my_aws_access_key
  secret_key = var.my_aws_secret_key
}