terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — stores tfstate in S3 with DynamoDB locking
  # Prevents two engineers from running terraform apply at the same time
  backend "s3" {
    bucket         = "myapp-terraform-state"       # Change to your S3 bucket
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "myapp-terraform-locks"       # DynamoDB table for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "myapp"
      ManagedBy = "Terraform"
    }
  }
}
