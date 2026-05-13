output "arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.this.arn
}