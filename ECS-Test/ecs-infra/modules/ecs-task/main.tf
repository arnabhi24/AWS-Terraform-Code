resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode(var.container_definitions)

  runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture        = "X86_64"
}

  dynamic "volume" {
    for_each = var.enable_efs ? [1] : []
    content {
      name = var.efs_volume_name

      efs_volume_configuration {
        file_system_id = var.efs_file_system_id

        authorization_config {
          access_point_id = var.efs_access_point_id
          iam             = "DISABLED"
        }

        transit_encryption = "ENABLED"
      }
    }
  }
}
