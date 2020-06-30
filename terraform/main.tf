provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "nhsd-apim-terraform"
    region  = "eu-west-1"
  }
}

