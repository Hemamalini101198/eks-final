variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public1_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = string
}

variable "public2_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = string
}

variable "private1_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = string
}

variable "private2_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = string
}

variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}

variable "desired_nodes" {
  description = "Number of managed node desired size"
  type        = number
}

variable "min_nodes" {
  description = "Number of managed node minimum size"
  type        = number
}

variable "max_nodes" {
  description = "Number of managed node maximum size"
  type        = number
}

variable "project_name_env" {
  description = "project_name_env"
  type        = string  
}

variable "eks_node_name"{
  description = "name for the managed node"
  type = string
}
