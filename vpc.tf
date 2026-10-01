resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"
}
# .... private subnet section ......#
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.100.0/24"
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.200.0/24"
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "private2"
  }
}
resource "aws_subnet" "db-private1" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.50.0/28"
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "db-private1"
  }
  
}
resource "aws_subnet" "db-private2" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.60.0/28"
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "db-private2"
  }
}
# .... public subnets section ......#
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "public2"
  }
}
# .... pubic subnets configurtion section ......#
resource "aws_internet_gateway" "vpc-gw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "custom vpc"
  }
}
resource "aws_route_table" "public-TB" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-gw.id
  }

  tags = {
    Name = "public route table"
  }
}
resource "aws_route_table_association" "pub-subnet-joins" {
  count = 2
  subnet_id      = local.pubnet-ids[count.index]
  route_table_id = aws_route_table.public-TB.id
}
# .... private subnets configurtion section ......#
resource "aws_eip" "natip" {
  tags = {
    Name = "natgateway"
  }
}
resource "aws_nat_gateway" "natgateway" {
  connectivity_type = "public"
  allocation_id = aws_eip.natip.id
  region = var.region
  subnet_id = local.pubnet-ids[0]
  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.vpc-gw]
}

resource "aws_route_table" "private-tb" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway.id
  }

  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "prv-subnet-joins" {
  count = 2
  subnet_id      = local.prvnet-ids[count.index]
  route_table_id = aws_route_table.private-tb.id
}
resource "aws_route_table_association" "db-subnet-joins" {
  count = 2
  subnet_id      = local.dbnet-ids[count.index]
  route_table_id = aws_route_table.private-tb.id
}