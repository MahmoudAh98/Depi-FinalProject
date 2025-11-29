output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Certificate authority data for EKS cluster"
  value       = module.eks.cluster_certificate_authority
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider for EKS"
  value       = module.eks.oidc_provider_arn
}

output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = module.eks.node_group_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.ec2.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.ec2.instance_id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}