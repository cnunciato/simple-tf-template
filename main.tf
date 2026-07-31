terraform {
  backend "remote" {
    hostname     = "api.pulumi.com"
    organization = "cnunciato"

    workspaces {
      name = "my-infra_dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "my_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "my-infra-example-bucket"

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
    SomeKey     = "some-value"
  }
}

output "bucket_arn" {
  value = module.my_bucket.bucket_arn
}
