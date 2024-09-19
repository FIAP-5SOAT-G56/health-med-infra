terraform {
  required_version = ">= 1.7.4"

  backend "s3" {
    bucket = "fiap-health-med-tfstate"
    key    = "fiap-health-med-infra.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      environment = var.environment
      app         = var.resource_prefix
      project     = var.resource_prefix
    }
  }
}
