resource "aws_security_group" "service" {
  vpc_id     = var.vpc_id
  name       = "${var.name}-sg"
  description = "SG for ECS service ${var.name}"
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for i, r in var.ingress_rules : i => r }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.service.id

  cidr_blocks = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null

  source_security_group_id = (
    each.value.source_security_group_id != "" ?
    each.value.source_security_group_id :
    null
  )
}

resource "aws_security_group_rule" "egress" {
  for_each = { for i, r in var.egress_rules : i => r }

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.service.id
}


resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

    health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = var.path_patterns
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 500

  depends_on = [aws_lb_listener_rule.this]

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
