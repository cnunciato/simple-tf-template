terraform {
  # backend "remote" {
  #   hostname     = "tf.pulumi.com"
  #   organization = "cnunciato"  #
  #   workspaces {
  #     name = "my-infra_dev"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "s3-bucket" {
  # source  = "tf.pulumi.com/veridian/s3-bucket/aws"
  # version = "0.1.5"
  source = "./modules/s3-bucket"
  bucket_name = "my-infra-example-bucket"

  tags = {
    Environment = "dev"
  }
}

output "bucket_arn" {
  value = module.s3-bucket.bucket_arn
}
