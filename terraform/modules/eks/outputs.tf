output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.eks.id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = aws_eks_cluster.eks.version
}

output "cluster_certificate_authority" {
  description = "Certificate authority data for EKS cluster"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  value       = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider"
  value       = aws_iam_openid_connect_provider.oidc.url
}

output "node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.nodes.id
}

output "node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.nodes.status
}

output "node_role_arn" {
  description = "ARN of the node IAM role"
  value       = aws_iam_role.nodes.arn
}