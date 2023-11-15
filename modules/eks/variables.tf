variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

variable "private1_subnet_cidrs" {
  description = "List of subnet IDs for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}
