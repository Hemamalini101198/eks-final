variable "region"{
  type = string
}

variable "cluster_name" {
  type = string
  
}

variable "private1_subnet_cidr" {
  type = string
}
variable "private2_subnet_cidr" {
  type = string
}

variable "public1_subnet_id" {
  type = string
}

variable "public2_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sg_id" {
  type = string
}
/*
variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}
*/
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
/*
variable "eks_node_name"{
  description = "name for the managed node"
  type = string
}
*/
