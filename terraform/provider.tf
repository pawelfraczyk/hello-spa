/*
  https://www.terraform.io/docs/configuration/terraform.html
*/
terraform {
  required_version = "~> 0.12.18"
}

/*
  https://www.terraform.io/docs/configuration/providers.html#provider-versions
  https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
*/
provider "aws" {
  region  = var.region
  version = "~> 2.53.0"
}
provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  version = "~> 2.53.0"
}

terraform {
  # terraform.backend: configuration cannot contain interpolations
  backend "s3" {
    bucket         = "spa-prod-infrastructure"
    key            = "terraform/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "spa-prod-tf-locks"
  }
}

