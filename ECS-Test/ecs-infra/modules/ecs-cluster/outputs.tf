output "arn" {
  description = "ECS Cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.this.name
}
