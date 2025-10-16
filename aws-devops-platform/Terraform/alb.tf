variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}

# Security group for the ALB (HTTP now; TLS later)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "ALB ingress"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The ALB
resource "aws_lb" "app" {
  name               = "app-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}

# TG for EC2 (instance targets) - will serve "/"
resource "aws_lb_target_group" "tg_frontend" {
  name        = "tg-frontend"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path    = "/"
    matcher = "200-399"
  }
}

# TG for EKS backend (pod IP targets) - will serve "/api/*"
resource "aws_lb_target_group" "tg_backend" {
  name        = "tg-backend"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# TG for Lambda - will serve "/tasks/*"
resource "aws_lb_target_group" "tg_lambda" {
  name        = "tg-lambda"
  target_type = "lambda"
}

# HTTP listener with default action to frontend (empty for now → expect 503)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_frontend.arn
  }
}

# Path rules
resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_backend.arn
  }

  condition {
    path_pattern { values = ["/api/*"] }
  }
}

resource "aws_lb_listener_rule" "lambda_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_lambda.arn
  }

  condition {
    path_pattern { values = ["/tasks/*"] }
  }
}
