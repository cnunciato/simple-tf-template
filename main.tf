terraform {
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
  source = "./modules/s3-bucket"
  bucket_name = "my-tf-project-bucket"

  tags = {
    Environment = "dev"
  }
}

output "bucket_arn" {
  value = module.s3-bucket.bucket_arn
}
