resource "aws_security_group" "health_med_api_rds" {
  name        = "${var.resource_prefix}-health-med-api-sg-rds"
  description = "inbound: TCP/3306 + outbound: none"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-sg-rds"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_db_subnet_group" "health_med_api_rds" {
  name = "${var.resource_prefix}-health-med-api-subnet-group-rds"
  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_b.id
  ]

  tags = {
    Name = "${var.resource_prefix}-health-med-api-subnet-group-rds"
  }

  depends_on = [
    aws_subnet.subnet_private_a,
    aws_subnet.subnet_private_b
  ]
}

resource "aws_db_instance" "health_med_api" {
  instance_class       = var.db_instance_class
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  parameter_group_name = var.db_parameter_group_name

  identifier = "${var.resource_prefix}-health-med-api-rds"

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 0

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false
  db_name             = var.db_name
  username            = var.DB_USERNAME
  password            = var.DB_PASSWORD

  db_subnet_group_name   = aws_db_subnet_group.health_med_api_rds.name
  vpc_security_group_ids = [aws_security_group.health_med_api_rds.id]
  availability_zone      = var.default_az

  tags = {
    Name = "${var.resource_prefix}-health-med-api-rds"
  }

  depends_on = [
    aws_db_subnet_group.health_med_api_rds,
    aws_security_group.health_med_api_rds
  ]
}

output "health_med_api_db_endpoint" {
  value = aws_db_instance.health_med_api.endpoint
}
