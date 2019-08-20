variable "aws_region" {
	default = "us-east-1"
}

variable "vpc_cidr" {
	default = "172.16.0.0/16"
}

variable "subnets_cidr" {
	type = "list"
	default = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "azs" {
	type = "list"
	default = ["us-east-1a", "us-east-1b"]
}

variable "webservers_ami" {
  default = "ami-07d0cf3af28718ef8"
}

variable "instance_count" {
  default = "5"
}

variable "instance_type" {
  default = "t2.micro"
}

