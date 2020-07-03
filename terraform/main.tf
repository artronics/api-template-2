provider "aws" {
  version = "~> 2.0"
  region = "eu-west-1"
}

provider "apigee" {
  org = "jhosseinidev-eval"
  user = var.apigee_user
  access_token = var.apigee_access_token
}

terraform {
  backend "s3" {
    bucket = "nhsd-apim-terraform"
    region = "eu-west-1"
  }
}

module "apim-apigee-terraform" {
  source = "github.com/artronics/apim-apigee-terraform.git"
//  source = "../../apim-apigee-terraform"
  service_name = "api-template"
  service_base_path = "api-template"
  apigee_environment = "test"
  proxy_type = "sandbox"
  api_product_display_name = "Template Api"
}
