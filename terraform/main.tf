terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet1_cidr  = var.public_subnet1_cidr
  public_subnet2_cidr  = var.public_subnet2_cidr
  availability_zone_1  = var.availability_zone_1
  availability_zone_2  = var.availability_zone_2
  project_name         = var.project_name
}

# Security Group Module
module "security_group" {
  source = "./modules/security_group"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  subnet_ids          = module.vpc.public_subnet_ids
  iam_user_name       = var.iam_user_name
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_min_size       = var.node_min_size
  node_instance_types = var.node_instance_types
  project_name        = var.project_name
}

# EBS CSI Driver Module
module "ebs_csi" {
  source = "./modules/ebs_csi"

  cluster_name       = module.eks.cluster_name
  cluster_version    = module.eks.cluster_version
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
  
  depends_on = [module.eks]
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  subnet_id          = module.vpc.public_subnet1_id
  security_group_ids = [module.security_group.security_group_id]
  instance_type      = var.bastion_instance_type
  key_name           = var.key_name
  private_key_path   = var.private_key_path
  k8s_manifests_path = var.k8s_manifests_path
  project_name       = var.project_name

  depends_on = [
    module.eks
  ]
}