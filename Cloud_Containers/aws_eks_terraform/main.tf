# EKS Terraform module

module "eks" {
  source                   = "./modules/eks"
  aws-region               = var.aws-region
  cluster-name             = var.cluster-name
  node_instance_type       = var.node_instance_type
  desired-capacity         = var.desired-capacity
  max-size                 = var.max-size
  min-size                 = var.min-size
  eks-cw-logging           = var.eks-cw-logging
  subnet_ids 		       = var.subnet_ids
  key_pair_name            = var.key_pair_name
  cluster_private_access   = var.cluster_private_access
  cluster_public_access    = var.cluster_public_access
  node-group-name	       = var.node-group-name
}


