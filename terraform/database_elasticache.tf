resource "aws_security_group" "health_med_api_cache" {
  name        = "${var.resource_prefix}-health-med-api-sg-cache"
  description = "inbound: TCP/6379 + outbound: none"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Enable communication to the Amazon ElastiCache cluster. "
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-sg-cache"
  }
}

resource "aws_elasticache_subnet_group" "health_med_api_cache" {
  name = "${var.resource_prefix}-health-med-api-subnet-group-cache"
  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_b.id
  ]

  tags = {
    Name = "${var.resource_prefix}-health-med-api-subnet-group-cache"
  }

  depends_on = [
    aws_subnet.subnet_private_a,
    aws_subnet.subnet_private_b
  ]
}

resource "aws_elasticache_cluster" "health_med_api" {
  cluster_id        = "${var.resource_prefix}-health-med-api-cache"
  engine            = var.cache_engine
  node_type         = var.cache_node_type
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true

  subnet_group_name  = aws_elasticache_subnet_group.health_med_api_cache.name
  security_group_ids = [aws_security_group.health_med_api_cache.id]
  availability_zone  = var.default_az

  tags = {
    Name = "${var.resource_prefix}-health-med-api-cache"
  }

  depends_on = [
    aws_elasticache_subnet_group.health_med_api_cache,
    aws_security_group.health_med_api_cache
  ]
}

output "health_med_api_cache_endpoint" {
  value = aws_elasticache_cluster.health_med_api.cache_nodes[0].address
}
