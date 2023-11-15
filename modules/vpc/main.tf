resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw-test"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public1_subnet_cidrs
  #availability_zone       = "ap-south-1a"  
   
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public2_subnet_cidrs
  #availability_zone       = "ap-south-1a"  
  
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private1_subnet_cidrs
  #availability_zone       = "ap-south-1b"  
  # Associate this subnet with the shared route table
  
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private2_subnet_cidrs
  #availability_zone       = "ap-south-1b"  

  tags = {
    Name = "private-2"
  }
}

resource "aws_route_table_association" "public1_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_ip" {
  #vpc = true  
  #instance = null 
}


resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public1.id
  depends_on    = [aws_internet_gateway.eks_igw]
  tags = {
    #Name = "nat-${count.index + 1}"
    Name = "eks-nat-gw"
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
    Name = "rt-pvt"
  }
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "my-eks-sg" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*

resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  #availability_zone       = "ap-south-1a"  

  tags = {
    Name = "public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  #availability_zone       = "ap-south-1b"  

  tags = {
    Name = "private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw-test"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  count = length(var.public_subnet_cidrs)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_eip" "nat_ip" {
  #vpc = true  
  #instance = null 
}

resource "aws_nat_gateway" "eks_nat" {
  count        = length(aws_subnet.private)
  #allocation_id = aws_subnet.private[count.index].id
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    #Name = "nat-${count.index + 1}"
    Name = "eks-nat-gw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id
  count = length(var.private_subnet_cidrs)

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_nat_gateway.eks_nat[count.index].id
    gateway_id = aws_nat_gateway.eks_nat[count.index].id
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "my-eks-sg" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/