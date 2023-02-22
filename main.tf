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
  region = "ap-northeast-1"
}

resource "aws_vpc" "ex_vpc" {
    cidr_block = var.ex_vpc_cidr

    tags = {
        Name = "terraform-aws-vpc-ex-ppy"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.ex_vpc.id
    cidr_block = "10.0.10.0/24"

    tags = {
        Name = "terraform-aws-private_subnet-ex-ppy"
    }
  
}

resource "aws_security_group" "ppy_sg_terraform_test" {
  name = "sg_terraform_test"
    description = "Configuration Securty group for Terraform"
    vpc_id = aws_vpc.ex_vpc.id
    ingress {
        description = "Allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.sg_ingress_cidr]
    }
    ingress {
        description = "Allow Web"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.sg_ingress_cidr]
    }
    ingress {
        description = "Allow all protocol yang masuk"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.sg_ingress_cidr]
    }
    ingress {
        description = "Allow https from internet"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [aws_vpc.ex_vpc.cidr_block]
    }
    egress {
        description = "Allow semua protocol yang keluar"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.sg_egress_cidr]
    }
    tags = {
        Name = "sg_terraform_test"
    }
}

resource "aws_internet_gateway" "internet_gateway_terraform_ex" {
    vpc_id = aws_vpc.ex_vpc.id
    
    tags = {
        Name = "Internet gateway"
    }
}

resource "aws_route" "route_ex" {
    route_table_id = var.route_table_id
    destination_cidr_block = var.destination_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway_terraform_ex.id
}

resource "aws_instance" "lab_terraform_trial" {
    count                   = 1
    ami                     = var.aws_instance_ami
    instance_type           = var.aws_instance_type
    vpc_security_group_ids = [aws_security_group.ppy_sg_terraform_test.id]
    subnet_id = aws_subnet.private_subnet.id
    associate_public_ip_address = false
    tags = {
        Name = "lab-terraform-trial"
        Owner = "Pepi"
    }
}

resource "aws_sagemaker_code_repository" "sagemaker_repo_example" {
  code_repository_name = var.sm_repo_name

  git_config {
    repository_url = var.sm_repo_git
  }
}


resource "aws_sagemaker_notebook_instance" "notebook_example" {
  name                    = "notebook-example-instance"
  role_arn                = var.sm_nb_role_arn
  instance_type           = var.sm_nb_type
  default_code_repository = aws_sagemaker_code_repository.sagemaker_repo_example.code_repository_name

  tags = {
    Name = "nb_example"
  }
}


resource "aws_codecommit_repository" "cc_repo" {
  repository_name = var.cc_repo_name
}

# resource "aws_codecommit_trigger" "cc_trigger" {
#   repository_name = "aws_codecommit_repository.cc_repo.repository_name"

#   trigger {
#     name            = "all"
#     events          = ["all"]
#     branches        = ["main"]
#     destination_arn = "arn:aws:codecommit:ap-northeast-1:959896818063:cc_repo_test"
#   }
# }