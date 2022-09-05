terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

/* This is used to get local ip address */
data "http" "local_ip" {
  url = "https://checkip.amazonaws.com"
}

provider "aws" {
  profile = "default"
  region  = var.instance_region
}

resource "aws_default_vpc" "main" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow everything tcp inbound"
  vpc_id = aws_default_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.local_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_inbound"
  }
}

resource "aws_instance" "github_actions_runner" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.allow_inbound.id]

  user_data = templatefile("init.sh", {
    github_repo_url = var.github_repo_url
    github_repo_token = var.github_repo_token
    github_runner_version = var.github_runner_version
    runner_name = var.runner_name
  })

  tags = {
    Name = "github-runner"
  }
}

output "public_ip" {
  value = "${aws_instance.github_actions_runner.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.github_actions_runner.*.public_dns}"
}
