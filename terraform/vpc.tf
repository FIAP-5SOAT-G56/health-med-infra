resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.resource_prefix}-vpc",
  }
}

# Outputs
output "aws_vpc_id" {
  value = aws_vpc.default.id
}
