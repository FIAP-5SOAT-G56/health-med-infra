resource "aws_security_group" "health_med_api_lb" {
  name        = "${var.resource_prefix}-health-med-api-sg-lb"
  description = "Inbound: 80 (HTTP), 443 (HTTPS) + Outbound: all"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-sg-lb"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_alb" "health_med_api" {
  name               = "${var.resource_prefix}-api-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet_public_a.id, aws_subnet.subnet_public_b.id]
  security_groups    = [aws_security_group.health_med_api_lb.id]

  tags = {
    Name = "${var.resource_prefix}-health-med-api-lb"
  }

  depends_on = [
    aws_subnet.subnet_public_a,
    aws_subnet.subnet_public_b,
    aws_security_group.health_med_api_lb
  ]
}

resource "aws_alb_target_group" "health_med_api" {
  name                 = "${var.resource_prefix}-api-lb-tg"
  port                 = 3000
  protocol             = "HTTP"
  vpc_id               = aws_vpc.default.id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 180
    matcher             = "200-299,301,302"
    enabled             = true
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-lb-tg"
  }

  depends_on = [
    aws_vpc.default
  ]
}

resource "aws_alb_listener" "health_med_api" {
  load_balancer_arn = aws_alb.health_med_api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.health_med_api.arn
    type             = "forward"
  }

  tags = {
    Name = "${var.resource_prefix}-health-med-api-lb-listener"
  }

  depends_on = [
    aws_alb.health_med_api,
    aws_alb_target_group.health_med_api
  ]
}
