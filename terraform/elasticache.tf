resource "aws_security_group" "cache" {
  name        = "${var.resource_prefix}-security-group-cache"
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
    Name = "${var.resource_prefix}-security-group-cache"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name = "${var.resource_prefix}-subnet-group-cache"
  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_b.id
  ]

  tags = {
    Name = "${var.resource_prefix}-subnet-group-cache"
  }
}

resource "aws_elasticache_cluster" "default" {
  cluster_id        = "${var.resource_prefix}-cache"
  engine            = var.cache_engine
  node_type         = var.cache_node_type
  num_cache_nodes   = 1
  port              = 6379
  apply_immediately = true

  subnet_group_name  = aws_elasticache_subnet_group.default.name
  security_group_ids = [aws_security_group.cache.id]
  availability_zone  = var.default_az
}

output "aws_elasticache_cluster_endpoint" {
  value = aws_elasticache_cluster.default.cache_nodes[0].address
}
