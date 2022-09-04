resource "aws_ecr_repository_policy" "e-shop-repo-policy" {
  repository = aws_ecr_repository.eshop-repo.name

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "Adds full ecr access to our repo",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
  role       = "arn:aws:iam::${var.aws_account_id}:role/eksClusterRole"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy" {
  role       = "arn:aws:iam::${var.aws_account_id}:role/EKSworkerNodePolicy"
  count      = length(var.managed_policies)
  policy_arn = element(var.managed_policies, count.index)
}

resource "aws_iam_role_policy_attachment" "eks_service_role_eks_node_group_policy" {
  role       = "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
  policy_arn = "arn:aws:iam::aws:policy/AmazonServiceRoleForAmazonEKSNodeGroup"
}

resource "aws_iam_role_policy_attachment" "eks_service_role_amazon_eks" {
  role       = "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}