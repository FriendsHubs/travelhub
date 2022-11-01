data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "travelhub_vpc" {
  cidr_block = "10.32.0.0/16"
  tags = {
    "Name" = var.project_name
  }
}

resource "aws_subnet" "travelhub_public_subnet" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.travelhub_vpc.cidr_block, 8, 1 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.travelhub_vpc.id
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.project_name
  }

}

resource "aws_subnet" "travelhub_private_subnet" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.travelhub_vpc.cidr_block, 8, 3 + count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.travelhub_vpc.id

  tags = {
    "Name" = var.project_name
  }
}

resource "aws_internet_gateway" "travelhub_igw" {
  vpc_id = aws_vpc.travelhub_vpc.id
  tags = {
    "Name" = var.project_name
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_vpc.travelhub_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.travelhub_igw.id

}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.travelhub_igw]

  tags = {
    "Name" = var.project_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = element(aws_subnet.travelhub_public_subnet[*].id, 0)
  allocation_id = aws_eip.nat_eip.id
  tags = {
    "Name" = var.project_name
  }

}

resource "aws_route" "private_route" {
  depends_on             = [aws_nat_gateway.nat_gw]
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.travelhub_vpc.id

  tags = {
    "Name" = var.project_name
  }
}

resource "aws_route_table_association" "private_rtb_assoc" {
  count          = 2
  subnet_id      = element(aws_subnet.travelhub_private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rtb[*].id, count.index)

}