variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "Availability zone for subnet 1"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability zone for subnet 2"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}