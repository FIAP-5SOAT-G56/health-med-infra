resource "aws_eip" "default" {
  domain = "vpc"

  tags = {
    Name = "${var.resource_prefix}-elastic-ip"
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = aws_subnet.subnet_public_a.id

  tags = {
    Name = "${var.resource_prefix}-nat-gateway"
  }

}

resource "aws_subnet" "subnet_private_a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-subnet-private-a"
  }
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-subnet-private-b"
  }
}

resource "aws_route_table" "rtb_private_a" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.default.id
  }

  tags = {
    Name = "${var.resource_prefix}-rtb-private-a"
  }
}

resource "aws_route_table_association" "rtb_private_a" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.rtb_private_a.id
}

resource "aws_route_table" "rtb_private_b" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.default.id
  }

  tags = {
    Name = "${var.resource_prefix}-rtb-private-b"
  }
}

resource "aws_route_table_association" "rtb_private_b" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_route_table.rtb_private_b.id
}

# Outputs
output "subnet_private_a_id" {
  value = aws_subnet.subnet_private_a.id
}

output "subnet_private_b_id" {
  value = aws_subnet.subnet_private_b.id
}
