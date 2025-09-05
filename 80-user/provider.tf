terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.98.0"
    }
  }
    backend "s3" {
      bucket = "sham-remote-state-dev"
      key = "roboshop-dev-user"
      region = "us-east-1"
      encrypt = true
      use_lockfile = true
    }

}

provider "aws" {
  # configuration options
  region = "us-east-1"
}