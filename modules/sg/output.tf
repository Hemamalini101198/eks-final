output "sg_vpc_id" {
  description = "sec grp id"
  value       = aws_security_group.my-eks-sg.id
}