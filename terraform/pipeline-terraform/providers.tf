terraform {
  backend "s3" {
    bucket = "fe-cluster-tf-state"
    region = "us-west-2"
    # Defined by config.yml
    #key            = "fe-platform-demo/port/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
  required_providers {
    circleci = {
      # currently depends on config.yml creation of ~/.terraform.d/plugins/circleci.com/circleci/circleci/0.0.1/linux_amd64 directory containing binary
      source = "CircleCI-Public/circleci"
      version = "0.2.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.0.0"
    }
  }
}

provider "circleci" {
  host = "https://circleci.com/api/v2/"
  #key  = "*****"
  # Using envvar CIRCLE_TOKEN
}

provider "github" {
  # token will be read from GITHUB_TOKEN environment variable automatically
  owner = var.github_owner
}