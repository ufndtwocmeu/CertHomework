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
  access_key = $MY_AWS_ACCESS_KEY
  secret_key = $MY_AWS_SECRET_KEY
}