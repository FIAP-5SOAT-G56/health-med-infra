data "aws_iam_policy_document" "ecs_task_definition" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_definition_role" {
  name               = "${var.resource_prefix}-ecs-task-definition_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_definition.json

  tags = {
    Name = "${var.resource_prefix}-health-med-api_ecs-task-definition_role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_definition" {
  role       = aws_iam_role.ecs_task_definition_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "health_med_api" {
  family                   = "health-med-api"
  requires_compatibilities = ["FARGATE"]
  track_latest             = true
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_definition_role.arn

  tags = {
    Name = "${var.resource_prefix}-health-med-api-ecs-task-definition"
  }

  depends_on = [
    aws_ecs_cluster.default,
    aws_db_instance.health_med_api,
    aws_elasticache_cluster.health_med_api
  ]

  container_definitions = jsonencode([
    {
      name      = "health-med-api",
      image     = "${aws_ecr_repository.health_med_api.repository_url}:latest",
      essential = true,
      cpu       = 256
      memory    = 512

      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 3000,
          hostPort      = 3000
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/health-med-api",
          awslogs-region        = "${var.region}",
          awslogs-stream-prefix = "ecs"
        }
      },

      healthcheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000 || exit 1"],
        timeout     = 5,
        interval    = 30,
        retries     = 3,
        startPeriod = null
      },

      environment = [
        {
          name  = "NODE_ENV",
          value = "production"
        },
        {
          name  = "DB_HOSTNAME",
          value = "<db_hostname>"
        },
        {
          name  = "DB_DATABASE",
          value = "<db_database>"
        },
        {
          name  = "DB_USER",
          value = "<db_user>"
        },
        {
          name  = "DB_PASSWORD",
          value = "<db_password>"
        },
        {
          name  = "REDIS_HOSTNAME",
          value = "<redis_hostname>"
        },
        {
          name  = "JWT_SECRET",
          value = "<jwt_secret>"
        }
      ]
    }
  ])
}
