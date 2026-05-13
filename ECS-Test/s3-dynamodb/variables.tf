variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "load_balancer_type" {
  type    = string
  default = "alb"
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}
