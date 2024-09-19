resource "aws_sns_topic" "api_appointment_created" {
  name = "${var.resource_prefix}-api_appointment-created"

  tags = {
    Name = "${var.resource_prefix}-api_appointment-created-topic"
  }
}

resource "aws_sns_topic" "api_appointment_cancelled" {
  name = "${var.resource_prefix}-api_appointment-cancelled"

  tags = {
    Name = "${var.resource_prefix}-api_appointment-cancelled-topic"
  }
}
