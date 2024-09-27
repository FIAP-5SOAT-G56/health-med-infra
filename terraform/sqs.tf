# =====================================================
# ============== api_appointment-created ==============
# =====================================================
resource "aws_sqs_queue" "api_appointment_created_dlq" {
  name                       = "${var.resource_prefix}-api_appointment-created_dlq"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  tags = {
    Name = "${var.resource_prefix}-api_appointment-created-dlq"
  }
}

resource "aws_sqs_queue" "api_appointment_created" {
  name                       = "${var.resource_prefix}-api_appointment-created"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.api_appointment_created_dlq.arn
    maxReceiveCount     = 4
  })

  tags = {
    Name = "${var.resource_prefix}-api_appointment-created-queue"
  }

  depends_on = [
    aws_sqs_queue.api_appointment_created_dlq
  ]
}

resource "aws_sns_topic_subscription" "api_appointment_created_subscription" {
  topic_arn = aws_sns_topic.api_appointment_created.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.api_appointment_created.arn

  depends_on = [
    aws_sns_topic.api_appointment_created,
    aws_sqs_queue.api_appointment_created
  ]
}

data "aws_iam_policy_document" "api_appointment_created_policy" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.api_appointment_created.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.api_appointment_created.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "api_appointment_created_queue_policy" {
  queue_url = aws_sqs_queue.api_appointment_created.id
  policy    = data.aws_iam_policy_document.api_appointment_created_policy.json

  depends_on = [
    aws_sqs_queue.api_appointment_created,
    data.aws_iam_policy_document.api_appointment_created_policy
  ]
}

output "sqs_api_appointment_created_arn" {
  value = aws_sqs_queue.api_appointment_created.arn
}

output "sqs_api_appointment_created_dlq_arn" {
  value = aws_sqs_queue.api_appointment_created_dlq.arn
}

# =====================================================
# ============= api_appointment-cancelled =============
# =====================================================
resource "aws_sqs_queue" "api_appointment_cancelled_dlq" {
  name                       = "${var.resource_prefix}-api_appointment-cancelled_dlq"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  tags = {
    Name = "${var.resource_prefix}-api_appointment-cancelled-dlq"
  }
}

resource "aws_sqs_queue" "api_appointment_cancelled" {
  name                       = "${var.resource_prefix}-api_appointment-cancelled"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.api_appointment_cancelled_dlq.arn
    maxReceiveCount     = 4
  })

  tags = {
    Name = "${var.resource_prefix}-api_appointment-cancelled-queue"
  }

  depends_on = [
    aws_sqs_queue.api_appointment_cancelled_dlq
  ]
}

resource "aws_sns_topic_subscription" "api_appointment_cancelled_subscription" {
  topic_arn = aws_sns_topic.api_appointment_cancelled.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.api_appointment_cancelled.arn
}

data "aws_iam_policy_document" "api_appointment_cancelled_policy" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.api_appointment_cancelled.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.api_appointment_cancelled.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "api_appointment_cancelled_queue_policy" {
  queue_url = aws_sqs_queue.api_appointment_cancelled.id
  policy    = data.aws_iam_policy_document.api_appointment_cancelled_policy.json

  depends_on = [
    aws_sqs_queue.api_appointment_cancelled,
    data.aws_iam_policy_document.api_appointment_cancelled_policy
  ]
}

output "sqs_api_appointment_cancelled_arn" {
  value = aws_sqs_queue.api_appointment_cancelled.arn
}

output "sqs_api_appointment_cancelled_dlq_arn" {
  value = aws_sqs_queue.api_appointment_cancelled_dlq.arn
}