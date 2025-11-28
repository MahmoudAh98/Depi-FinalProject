###############################################
# 1) EKS Cluster Data Sources
###############################################

data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}


###############################################
# 2) OIDC Provider for IRSA
###############################################

resource "aws_iam_openid_connect_provider" "oidc" {
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd0edf5"]
}


###############################################
# 3) IAM Role (IRSA) for EBS CSI Driver
###############################################

data "aws_iam_policy_document" "ebs_csi_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_irsa" {
  name               = "EBS-CSI-IRSA"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = aws_iam_role.ebs_csi_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


###############################################
# 4) Get Most Recent EBS-CSI Addon Version
###############################################

data "aws_eks_addon_version" "ebs" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.eks.version
  most_recent        = true
}


###############################################
# 5) Create the EKS Addon (FIXED)
###############################################

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "aws-ebs-csi-driver"

  addon_version            = data.aws_eks_addon_version.ebs.version
  service_account_role_arn = aws_iam_role.ebs_csi_irsa.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  preserve                    = true

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_policy,
    aws_eks_node_group.nodes
  ]
}
