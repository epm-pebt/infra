data "aws_availability_zones" "available" {}

resource "aws_vpc" "music-app" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

#======================internet_gateway==============================================

resource "aws_internet_gateway" "back_igw" {
  vpc_id = aws_vpc.music-app.id

  tags = {
    Name = "${var.env}-igw"
  }
}

#==============Public-subnet========================================================

resource "aws_subnet" "Back_public-subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.music-app.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

#=====================aws_route_table==============================================

resource "aws_route_table" "Back_public-subnet" {
  vpc_id = aws_vpc.music-app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.back_igw.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

resource "aws_route_table_association" "public_routers" {
  count = length(aws_subnet.Back_public-subnet[*].id)
  route_table_id = aws_route_table.Back_public-subnet.id
  subnet_id      = element(aws_subnet.Back_public-subnet[*].id, count.index)  
}

#============================aws_eip=aws_nat_gateway===================================

resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.Back_public-subnet[*].id, count.index)

  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}
#==================Private-subnet====================================================

resource "aws_subnet" "Back_private-subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.music-app.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index + 1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}
resource "aws_route_table" "Back_private-subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.music-app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-private-subnets-${count.index + 1}"
  }
}

resource "aws_route_table_association" "Private-routes" {
  count = length(aws_subnet.Back_private-subnet[*].id)
  route_table_id = aws_route_table.Back_private-subnet[count.index].id
  subnet_id      = element(aws_subnet.Back_private-subnet[*].id, count.index)  
}
#===============================================================================

