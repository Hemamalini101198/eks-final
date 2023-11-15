variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public1_subnet_cidrs" {
  description = "List of subnet IDs for the ALB"
  type        = string
}