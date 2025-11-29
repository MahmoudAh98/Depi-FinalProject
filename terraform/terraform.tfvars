# AWS Configuration
aws_region   = "us-east-1"
project_name = "EKS"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet1_cidr  = "10.0.1.0/24"
public_subnet2_cidr  = "10.0.2.0/24"
availability_zone_1  = "us-east-1a"
availability_zone_2  = "us-east-1b"

# EKS Configuration
cluster_name     = "EKS_Cluster"
cluster_version  = "1.34"
iam_user_name    = "mahmoud"

# Node Group Configuration
node_desired_size   = 2
node_max_size       = 2
node_min_size       = 2
node_instance_types = ["t3.small"]

# Bastion Configuration
bastion_instance_type = "t3.micro"
key_name              = "mahmoud"
private_key_path      = "../script/mahmoud.pem"
k8s_manifests_path    = "../k8s/"