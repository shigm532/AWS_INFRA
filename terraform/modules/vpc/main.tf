resource "aws_vpc" "vpc1dev" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true 
  enable_dns_support = true 

  tags = {
    Name = var.vpc_name 
    Environment = var.environment
  }
}

resource "aws_subnet" "public1_dev" {
  vpc_id = aws_vpc.vpc1dev.id
  cidr_block = var.public_subnet_1
  availability_zone = var.az_1

  tags = {
    Name = "${var.environment}-public-1"
  }
}

resource "aws_subnet" "public2_dev" {
  vpc_id = aws_vpc.vpc1dev.id
  cidr_block = var.public_subnet_2
  availability_zone = var.az_2

  tags = {
    Name = "${var.environment}-public-2"
  }
}

resource "aws_subnet" "private1_dev" {
  vpc_id = aws_vpc.vpc1dev.id
  cidr_block = var.private_subnet_1
  availability_zone = var.az_1

  tags = {
    Name = "${var.environment}-private-1"
  }
}

resource "aws_subnet" "private2_dev" {
  vpc_id = aws_vpc.vpc1dev.id
  cidr_block = var.private_subnet_2
  availability_zone = var.az_2

  tags = {
    Name = "${var.environment}-private-2"
  }
}

resource "aws_internet_gateway" "igw_dev" {
  vpc_id = aws_vpc.vpc1dev.id

  tags = {
    Name = "dev-igw"
    environment = var.environment

  }
}

resource "aws_route_table" "public_rt_dev" {
  vpc_id = aws_vpc.vpc1dev.id

  tags = {
    Name = "dev-public-rt"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt_dev.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_dev.id
}

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1_dev.id
  route_table_id = aws_route_table.public_rt_dev.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2_dev.id
  route_table_id = aws_route_table.public_rt_dev.id
}



####  ELASTIC IP FOR NAT ######

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


#### NAT Gateway (in Public Subnet) #####

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1_dev.id

  depends_on = [aws_internet_gateway.igw_dev]
}


######  Private Route Table  ######

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc1dev.id
}


#### Route Private Traffic via NAT  ####


resource "aws_route" "private_internet_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


######  Associate Private Subnets  ######

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1_dev.id
  route_table_id = aws_route_table.private_rt.id
}












 





 





 





 






 



 



 



 
