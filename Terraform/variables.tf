variable "vpc" {
  type = string
}

variable "eks_cluster" {
  default = "eshop_cluster"
}

variable "managed_policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
}

variable "aws_account_id" {
  type = string
}

variable "kubernetes_version" {
  default = "1.21"
}