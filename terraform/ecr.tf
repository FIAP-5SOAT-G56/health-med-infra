resource "aws_ecr_repository" "health_med_api" {
  name                 = "${var.resource_prefix}-ecr/fiap-health-med-api"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "health_med_api" {
  repository = aws_ecr_repository.health_med_api.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire images older than 7 days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 7
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}
