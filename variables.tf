variable "instance_region" {
  description = "EC2 Instance region"
  type        = string
}

variable "ami" {
  description = "The AMI for the GitHub Runner backing EC2 Instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance backing the GitHub Runner"
  type        = string
}

variable "key_name" {
  description = "The KeyPair name for accessing (SSH) into the EC2 instance backing the GitHub Runner"
  type        = string
}

variable "github_repo_url" {
  description = "The GitHub Repo URL for which the GitHub Runner to be registered with"
  type        = string
}

variable "github_repo_token" {
  description = "The GitHub Repo Pat Token that would be used by the GitHub Runner to authenticate with the GitHub Repo"
  type        = string
}

variable "github_runner_version" {
  description = "GitHub Runner version"
  type        = string
}

variable "runner_name" {
  description = "The name to give to the GitHub Runner so you can easily identify it"
  type        = string
}
