output "ebs_csi_role_arn" {
  description = "ARN of the EBS CSI driver IAM role"
  value       = aws_iam_role.ebs_csi_irsa.arn
}

output "ebs_csi_addon_version" {
  description = "Version of the EBS CSI driver addon"
  value       = aws_eks_addon.ebs_csi.addon_version
}
