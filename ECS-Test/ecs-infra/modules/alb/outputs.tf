output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb["alb"].id
}

output "http_listener_arn" {
  description = "HTTP listener ARN"
  value       = aws_lb_listener.http.arn
}
