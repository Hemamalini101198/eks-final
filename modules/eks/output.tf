output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint  
}

#output "eks_node_group_role_arn" {
 # description = "ARN of the IAM role associated with the EKS node group"
  #value       = module.node_group.eks_node_group_role_arn
#}