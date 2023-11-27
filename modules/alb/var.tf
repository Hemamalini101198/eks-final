variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}

variable "sg_id" {
  type        = string
}

variable "vpc_cidr" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public1_subnet_cidr" {
  description = "List of subnet IDs for the ALB"
  type        = string
}

variable "public2_subnet_cidr" {
  description = "List of subnet IDs for the ALB"
  type        = string
}