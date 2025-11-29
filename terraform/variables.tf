variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "EKS"
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "Availability zone for subnet 1"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Availability zone for subnet 2"
  type        = string
  default     = "us-east-1b"
}

# EKS Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "EKS_Cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.34"
}

variable "iam_user_name" {
  description = "IAM user name for EKS access"
  type        = string
  default     = "mahmoud"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

# EC2 Bastion Variables
variable "bastion_instance_type" {
  description = "Instance type for EC2 bastion host"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "mahmoud"
}

variable "private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "../script/mahmoud.pem"
}

variable "k8s_manifests_path" {
  description = "Path to Kubernetes manifests directory"
  type        = string
  default     = "../k8s/"
}