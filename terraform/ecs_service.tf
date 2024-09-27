resource "aws_security_group" "health_med_api_ecs_service" {
  name        = "${var.resource_prefix}-health-med-api-sg-ecs-service"
  description = "Inbound: All + Outbound: All"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.health_med_api_lb.id]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-sg-ecs-service"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_ecs_service" "health_med_api" {
  name                              = "${var.resource_prefix}-health-med-api-ecs-service"
  cluster                           = aws_ecs_cluster.default.id
  task_definition                   = aws_ecs_task_definition.health_med_api.arn
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"
  health_check_grace_period_seconds = 10

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  desired_count                      = var.ecs_service_desired_count

  network_configuration {
    subnets = [
      aws_subnet.subnet_public_a.id,
      aws_subnet.subnet_public_b.id
    ]
    security_groups = [
      aws_security_group.health_med_api_rds.id,
      aws_security_group.health_med_api_cache.id,
      aws_security_group.health_med_api_ecs_service.id
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.health_med_api.arn
    container_name   = "health-med-api"
    container_port   = 3000
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-ecs-service"
  }

  depends_on = [
    aws_alb_listener.health_med_api,
    aws_ecs_cluster.default,
    aws_ecs_task_definition.health_med_api,
  ]
}

resource "aws_cloudwatch_log_group" "health_med_api_ecs_service" {
  name              = "/ecs/health-med-api"
  retention_in_days = 30

  tags = {
    Name = "${var.resource_prefix}-health-med-api-ecs-service-log-group"
  }
}
