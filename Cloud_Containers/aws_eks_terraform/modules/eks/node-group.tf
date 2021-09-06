variable "desired-capacity" {
}

variable "max-size" {
}

variable "min-size" {
}

variable "key_pair_name" {
}
 
variable "node_instance_type" {
}

variable "node-group-name" {
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = "${var.cluster-name}"
  count           = length(var.node-group-name)
  node_group_name = "${var.cluster-name}-node-group"
  node_role_arn   = "${aws_iam_role.node.arn}"
  subnet_ids      = var.subnet_ids
  instance_types  = var.node_instance_type
  remote_access {
      ec2_ssh_key = var.key_pair_name
  }
  tags = {
    Name = var.cluster-name
  }

  scaling_config {
    desired_size     = var.desired-capacity
    max_size         = var.max-size
    min_size         = var.min-size
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]
}
