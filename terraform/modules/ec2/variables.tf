variable "subnet_id" {
  description = "Subnet ID where EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to EC2 instance"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to SSH private key file"
  type        = string
}

variable "k8s_manifests_path" {
  description = "Path to Kubernetes manifests directory"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}