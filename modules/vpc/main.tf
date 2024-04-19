data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
}

#======================internet_gateway==============================================

resource "aws_internet_gateway" "back_igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { "Name" = "${var.name}-igw" },
    var.tags,
  )
}

#==============Public-subnet========================================================

resource "aws_subnet" "Back_public-subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.name}-public-${count.index + 1}" }, 
    var.tags,
  )
}

#=====================aws_route_table==============================================

resource "aws_route_table" "Back_public-subnet" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.back_igw.id
  }
  tags = merge(
    { Name = "${var.name}-route-public-subnets" },
    var.tags,
  )
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
  tags = merge(
    { Name = "${var.name}-nat-gw-${count.index + 1}" },
    var.tags,
  )
}

resource "aws_nat_gateway" "nat" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.Back_public-subnet[*].id, count.index)

  tags = merge(
    { Name = "${var.name}-nat-gw-${count.index + 1}" },
    var.tags,
  )
}
#==================Private-subnet====================================================

resource "aws_subnet" "Back_private-subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index + 1]
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.name}-private-${count.index + 1}" },
    var.tags,
  )
}

resource "aws_route_table" "Back_private-subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(
    { Name = "${var.name}-route-private-subnets-${count.index + 1}" },
    var.tags,
  )
}

resource "aws_route_table_association" "Private-routes" {
  count = length(aws_subnet.Back_private-subnet[*].id)
  route_table_id = aws_route_table.Back_private-subnet[count.index].id
  subnet_id      = element(aws_subnet.Back_private-subnet[*].id, count.index)  
}
#===============================================================================

