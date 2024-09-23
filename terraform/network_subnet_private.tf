resource "aws_subnet" "subnet_private_a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-subnet-private-a"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-subnet-private-b"
  }

  depends_on = [
    aws_vpc.default
  ]
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

  depends_on = [
    aws_nat_gateway.default
  ]
}

resource "aws_route_table_association" "rtb_private_a" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.rtb_private_a.id

  depends_on = [
    aws_subnet.subnet_private_a,
    aws_route_table.rtb_private_a
  ]
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

  depends_on = [
    aws_nat_gateway.default
  ]
}

resource "aws_route_table_association" "rtb_private_b" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_route_table.rtb_private_b.id

  depends_on = [
    aws_subnet.subnet_private_b,
    aws_route_table.rtb_private_b
  ]
}

# Outputs
output "subnet_private_a_id" {
  value = aws_subnet.subnet_private_a.id
}

output "subnet_private_b_id" {
  value = aws_subnet.subnet_private_b.id
}
