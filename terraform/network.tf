resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.resource_prefix}-igw"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_eip" "default" {
  domain = "vpc"

  tags = {
    Name = "${var.resource_prefix}-elastic-ip"
  }

  depends_on = [
    aws_internet_gateway.default
  ]
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = aws_subnet.subnet_public_a.id

  tags = {
    Name = "${var.resource_prefix}-nat-gateway"
  }

  depends_on = [
    aws_eip.default,
    aws_subnet.subnet_public_a
  ]
}
