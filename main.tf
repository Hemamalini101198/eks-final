provider "aws" {
  region = "ap-south-1" 
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  cidr_block           = var.cidr_block
  public1_subnet_cidr  = var.public1_subnet_cidr
  public2_subnet_cidr  = var.public2_subnet_cidr
  private1_subnet_cidr = var.private1_subnet_cidr
  private2_subnet_cidr = var.private2_subnet_cidr
  project_name_env = var.project_name_env
}

module "sg" {
  source               = "./modules/sg"
  vpc_id = module.vpc.vpc_id  
  project_name_env = var.project_name_env
}


module "alb" {
  source           = "./modules/alb"
  alb_name         = var.alb_name
  vpc_cidr = var.cidr_block
  public1_subnet_cidr = module.vpc.public1_subnet_id
  public2_subnet_cidr = module.vpc.public2_subnet_id
  sg_id = module.sg.sg_vpc_id
  depends_on = [module.vpc,module.eks_cluster, module.sg]
}


module "eks_cluster" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster"
  eks-node = "eks-managed-node"
  sg_id = module.sg.sg_vpc_id
  private1_subnet_cidr = module.vpc.private1_subnet_id
  private2_subnet_cidr = module.vpc.private2_subnet_id
  public1_subnet_id =  module.vpc.public1_subnet_id
  public2_subnet_id =  module.vpc.public2_subnet_id
  vpc_id        = module.vpc.vpc_id
  desired_nodes = var.desired_nodes
  min_nodes = var.min_nodes
  max_nodes = var.max_nodes
  project_name_env = var.project_name_env
  
  depends_on = [ module.vpc ]
}
