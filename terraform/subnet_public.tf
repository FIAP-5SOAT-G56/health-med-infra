resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.resource_prefix}-igw"
  }
}

resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-subnet-public-a"
  }
}

resource "aws_subnet" "subnet_public_b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-subnet-public-b"
  }
}

resource "aws_default_route_table" "rtb_public" {
  default_route_table_id = aws_vpc.default.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.resource_prefix}-rtb-public"
  }
}

resource "aws_route_table_association" "rtb_public_a" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_vpc.default.default_route_table_id
}

resource "aws_route_table_association" "rtb_public_b" {
  subnet_id      = aws_subnet.subnet_public_b.id
  route_table_id = aws_vpc.default.default_route_table_id
}

# Outputs
output "subnet_public_a_id" {
  value = aws_subnet.subnet_public_a.id
}

output "subnet_public_b_id" {
  value = aws_subnet.subnet_public_b.id
}
