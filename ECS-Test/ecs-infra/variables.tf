############################################
# AWS / Networking
############################################
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets for ECS tasks"
  type        = list(string)
}

############################################
# ALB
############################################
variable "load_balancer_type" {
  description = "Load balancer type (alb or nlb)"
  type        = string
  default     = "alb"
}

############################################
# ECS
############################################
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "test-ecs-cluster"
}
