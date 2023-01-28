terraform {
  required_version = ">= 0.14.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.71.0"
    }

    http = {}
    null = {}
  }

  backend "s3" {
    bucket         = "terraform-state-storage-bucket-ceros-ski-app-backend"
    key            = "global/ec2_remote_dev_environment_state/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-dynamo-ceros"
    encrypt        = true
  }
}

provider "aws" {
  region                  = var.aws-region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "vscode"
}
