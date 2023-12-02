provider "aws" {
  region = var.region 
}
/*
module "alb" {
  source           = "./modules/alb"
  alb_name         = var.alb_name
  vpc_cidr = var.cidr_block
  public1_subnet_cidr = 
  public2_subnet_cidr = 
  sg_id = 
}
*/
module "eks_cluster" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  eks-node = "eks-managed-node"
  sg_id = var.sg_id
  capacity_type = var.capacity_type
  instance_types = var.instance_types
  private1_subnet_cidr = var.private1_subnet_id
  private2_subnet_cidr = var.private2_subnet_id
  public1_subnet_id =  var.public1_subnet_id
  public2_subnet_id = var.public2_subnet_id
  vpc_id        = var.vpc_id
  desired_nodes = var.desired_nodes
  min_nodes = var.min_nodes
  max_nodes = var.max_nodes
  project_name_env = var.project_name_env
  ami_type = var.ami_type  
}

