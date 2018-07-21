variable "cluster_name" {
  type = "string"

  default = "test-eks"

  description = "The name of the EKS Cluster."
}

variable "vpc_name" {
  type = "string"

  default = "test-vpc"

  description = "The name of the VPC."
}

variable "region" {
  type = "string"

  default = "us-west-2"

  description = "The region for the EKS and VPC."
}

variable "asg_size" {
  type = "string"

  default = "8"

  description = "Auto scaling group size for worker nodes."
}

variable "aws_profile" {
  type = "string"

  default = "default"

  description = "The AWS profile to use."
}
