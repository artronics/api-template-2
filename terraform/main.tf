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

module "api-template" {
  source             = "github.com/artronics/apim-apigee-terraform.git"
  name               = "api-template"
  path               = "api-template"
  apigee_environment = var.apigee_environment
  proxy_type         = "sandbox"
  api_product_display_name = "Template Api"
}
