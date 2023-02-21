terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.3.0"
}

provider "aws" {
  region = "ap-southeast-1"
}


resource "aws_sagemaker_code_repository" "sagemaker_repo_example" {
  code_repository_name = "my-notebook-instance-example-code-repo"

  git_config {
    repository_url = "https://github.com/regakun/terraform-example.git"
  }
}


resource "aws_sagemaker_notebook_instance" "notebook_example" {
  name                    = "notebook-example-instance"
  role_arn                = "arn:aws:iam::959896818063:role/test_sagemaker_trrfm"
  instance_type           = "ml.t3.medium"
  default_code_repository = aws_sagemaker_code_repository.sagemaker_repo_example.code_repository_name

  tags = {
    Name = "nb_example"
  }
}

resource "aws_ecr_repository" "ecr_example" {
  name                 = "ecr_repo_example"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}