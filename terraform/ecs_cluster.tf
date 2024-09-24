resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name              = "/ecs/${var.resource_prefix}-ecs-cluster"
  retention_in_days = 30

  tags = {
    Name = "${var.resource_prefix}-ecs-cluster-log-group"
  }
}

resource "aws_ecs_cluster" "default" {
  name = "${var.resource_prefix}-ecs-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_cluster.name
      }
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.ecs_cluster
  ]
}
