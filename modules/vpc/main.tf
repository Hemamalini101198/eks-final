#vpc creation
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    name = "${var.project_name_env}-vpc-eks"
  }
}
#internet gateway creation
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    name = "${var.project_name_env}-igw-eks"
  }
}

#creation of routing table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = {
    name = "${var.project_name_env}-publicsubnet-rt-eks"
  }
}

#creation of public subnet1
resource "aws_subnet" "public1_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public1_subnet_cidr
  availability_zone       = "ap-south-1a"  
  map_public_ip_on_launch = true
   
  tags = {
    name = "${var.project_name_env}-publicsubnet1-eks"
  }
}

#creation of public subnet2
resource "aws_subnet" "public2_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public2_subnet_cidr
  #availability_zone       = "ap-south-1b"  
  map_public_ip_on_launch = true
  
  tags = {
    name = "${var.project_name_env}-publicsubnet2-eks"
  }
}

#creation of private subnet1
resource "aws_subnet" "private1_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private1_subnet_cidr
  availability_zone       = "ap-south-1a"  
  # Associate this subnet with the shared route table
  
  tags = {
    name = "${var.project_name_env}-privatesubnet1-eks"
  }
}

#creation of private subnet2
resource "aws_subnet" "private2_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private2_subnet_cidr
  availability_zone       = "ap-south-1b"  

  tags = {
    name = "${var.project_name_env}-privatesubnet2-eks"
  }
}

#routing table association for public subnet1
resource "aws_route_table_association" "public1_association" {
  subnet_id      = aws_subnet.public1_subnet.id
  route_table_id = aws_route_table.public.id
}


#routing table association for public subnet2
resource "aws_route_table_association" "public2_association" {
  subnet_id      = aws_subnet.public2_subnet.id
  route_table_id = aws_route_table.public.id
}

#elastic ip for nat gateway
resource "aws_eip" "nat_ip" {
  #vpc = true  
  #instance = null

  tags = {
    name = "${var.project_name_env}-eip-eks"
  } 
}


resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public1_subnet.id
  depends_on    = [aws_internet_gateway.eks_igw]
  
  tags = {
    name = "${var.project_name_env}-natgw-eks"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_nat_gateway.eks_nat[count.index].id
    gateway_id = aws_nat_gateway.eks_nat.id
  }
  tags = {
    name = "${var.project_name_env}-privatesubnet-rt-eks"
  }
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private1_subnet.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2_subnet.id
  route_table_id = aws_route_table.private.id
}

