terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

/* This is used to get local ip address */
data "http" "local_ip" {
  url = "https://checkip.amazonaws.com"
}

data "template_file" "init" {
  template = file("init.sh")
  vars = {
    github_repo_url = var.github_repo_url
    github_repo_token = var.github_repo_token
    runner_name = var.runner_name
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow everything tcp inbound"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.local_ip.body)}/32"]
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

  user_data = data.template_file.init.rendered

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
