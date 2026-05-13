variable "name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "lb_type" {
  description = "Type of load balancer: alb or nlb"
  type        = string
}

variable "subnets" {
  description = "Subnets for the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the load balancer will be created"
  type        = string
}