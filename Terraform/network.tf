data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "travel_hub" {
  cidr_block = "10.32.0.0/16"
  tags = {
    "Name" = var.project_name
  }
}


resource "aws_subnet" "travle_hub_public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.travel_hub.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.travel_hub.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "travle_hub_private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.travel_hub.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.travel_hub.id
}

resource "aws_internet_gateway" "travel_hub_gateway" {
  vpc_id = aws_vpc.travel_hub.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.travel_hub.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.travel_hub_gateway.id
}

resource "aws_eip" "travel_hub_eip" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.travel_hub_gateway]
}

resource "aws_nat_gateway" "travel_hub_nat_gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.travle_hub_public.*.id, count.index)
  allocation_id = element(aws_eip.travel_hub_eip.*.id, count.index)
}

resource "aws_route_table" "travel_hub_private_rtb" {
  count  = 2
  vpc_id = aws_vpc.travel_hub.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.travel_hub_nat_gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.travle_hub_private.*.id, count.index)
  route_table_id = element(aws_route_table.travel_hub_private_rtb.*.id, count.index)
}