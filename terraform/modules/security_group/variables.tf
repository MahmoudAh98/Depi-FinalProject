variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}