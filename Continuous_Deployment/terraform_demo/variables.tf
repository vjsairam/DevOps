variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "172.16.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "172.16.2.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI - Ubuntu"
  default = "ami-03b6f27628a4569c8"
}

variable "instance_count" {
  default = "5"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/ec2-user/.ssh/id_rsa.pub"
}
