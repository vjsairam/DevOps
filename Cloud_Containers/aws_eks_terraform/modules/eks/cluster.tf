# EKS Cluster Resources

provider "aws" {
  region = var.aws-region
}

variable "aws-region" { 
}

variable "cluster-name" {
}

variable "eks-cw-logging" {
}

variable "cluster_private_access" {
}

variable "cluster_public_access" {
}

variable "subnet_ids" {
}

resource "aws_eks_cluster" "eks" {
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.cluster.arn}"

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.cluster_private_access
    endpoint_public_access  = var.cluster_public_access

  }
  enabled_cluster_log_types = var.eks-cw-logging
  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
  ]
}
