terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-munish-apt-assignment"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-locks" # optional, for state locking
    encrypt        = true              # encrypt the state at rest
  }
}

provider "aws" {
  region = "us-east-1"
}
