# EKS Cluster Data Sources
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

# IAM Role (IRSA) for EBS CSI Driver
data "aws_iam_policy_document" "ebs_csi_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_irsa" {
  name               = "${var.cluster_name}-EBS-CSI-IRSA"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume.json

  tags = {
    Name = "${var.cluster_name}-EBS-CSI-IRSA"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = aws_iam_role.ebs_csi_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Get Most Recent EBS-CSI Addon Version
data "aws_eks_addon_version" "ebs" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

# Create the EKS Addon
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  addon_version            = data.aws_eks_addon_version.ebs.version
  service_account_role_arn = aws_iam_role.ebs_csi_irsa.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  preserve                    = true

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_policy
  ]

  tags = {
    Name = "${var.cluster_name}-ebs-csi-driver"
  }
}