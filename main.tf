provider "aws" {
  region = "ap-south-1" 
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  cidr_block           = var.cidr_block
  public1_subnet_cidrs  = var.public1_subnet_cidrs
  public2_subnet_cidrs  = var.public2_subnet_cidrs
  private1_subnet_cidrs = var.private1_subnet_cidrs
  private2_subnet_cidrs = var.private2_subnet_cidrs
}

module "alb" {
  source           = "./modules/alb"
  alb_name         = var.alb_name
  vpc_cidr = var.cidr_block
  public1_subnet_cidrs = var.public1_subnet_cidrs
  depends_on = [ module.vpc,module.eks_cluster ]
}


module "eks_cluster" {
  source        = "./modules/eks"
  cluster_name  = "my-eks-cluster"
  private1_subnet_cidrs = var.private1_subnet_cidrs
  vpc_id        = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}
