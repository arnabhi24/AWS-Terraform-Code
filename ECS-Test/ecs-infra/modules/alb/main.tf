########################################
# Local mappings
########################################
locals {
  # Map user-friendly input to Terraform-required values
  lb_type_map = {
    alb = "application"
    nlb = "network"
  }

  resolved_lb_type = local.lb_type_map[var.lb_type]
}

########################################
# Security Group (ONLY for ALB)
########################################
resource "aws_security_group" "alb" {
  for_each = var.lb_type == "alb" ? { alb = true } : {}

  name        = "${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

########################################
# Load Balancer (ALB or NLB)
########################################
resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = local.resolved_lb_type
  internal           = false
  subnets            = var.subnets

  # Only ALB supports security groups
  security_groups = (
  var.lb_type == "alb"
  ? [aws_security_group.alb["alb"].id]
  : null
)

  tags = {
    Name = var.name
  }
}

########################################
# HTTP Listener (Port 80)
########################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ALB is running"
      status_code  = "200"
    }
  }
}
