resource "aws_security_group" "rds" {
  name        = "${var.resource_prefix}-security-group-rds"
  description = "inbound: TCP/3306 + outbound: none"
  vpc_id      = aws_vpc.default.idid

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}-security-group-rds"
  }
}

resource "aws_db_subnet_group" "default" {
  name = "${var.resource_prefix}-subnet-group-rds"
  subnet_ids = [
    aws_subnet.subnet_private_a_id,
    aws_subnet.subnet_private_b_id
  ]

  tags = {
    Name = "${var.resource_prefix}-subnet-group-rds"
  }
}

resource "aws_db_instance" "default" {
  instance_class       = var.db_instance_class
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  parameter_group_name = var.db_parameter_group_name

  identifier = "${var.resource_prefix}-rds"

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 0

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false
  db_name             = var.db_name
  username            = var.DB_USERNAME
  password            = var.DB_PASSWORD

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  availability_zone      = var.default_az

  tags = {
    Name = "${var.resource_prefix}-rds"
  }
}

output "aws_db_instance_endpoint" {
  value = aws_db_instance.default.endpoint
}
