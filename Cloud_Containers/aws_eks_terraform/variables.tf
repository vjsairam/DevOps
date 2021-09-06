# Variables Configuration

variable "cluster-name" {
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.18"
  type        = string
  description = "Required K8s version"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet CIDR"
}

variable "eks-cw-logging" {
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type        = list
  description = "Enable EKS CWL for EKS components"
}

variable "node_instance_type" {
  type        = list(string)
  description = "Worker Node EC2 instance type"
}


variable "desired-capacity" {
  default     = 2
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 5
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}


variable "key_pair_name" {
  type        = string
  description = "AWS EC2 public key data"
}

variable "cluster_private_access" {
  default     = true	
  type 	      = string
  description = "Cluster end point access"
}

variable "cluster_public_access" {
  default     = false
  type        = string
  description = "Cluster end point access"
}

variable "node-group-name" {
  description = "provide node group names"
  type        = list(string)
}
