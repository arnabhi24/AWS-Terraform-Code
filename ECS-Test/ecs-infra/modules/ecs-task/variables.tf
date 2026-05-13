variable "family" {
  description = "Task definition family"
  type        = string
}

variable "cpu" {
  description = "CPU units"
  type        = string
}

variable "memory" {
  description = "Memory"
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
}

variable "container_definitions" {
  description = "Container definitions JSON"
  type        = any
}

variable "enable_efs" {
  description = "Enable EFS volume for task"
  type        = bool
  default     = false
}

variable "efs_volume_name" {
  type    = string
  default = null
}

variable "efs_file_system_id" {
  type    = string
  default = null
}

variable "efs_access_point_id" {
  type    = string
  default = null
}


variable "efs_ap" {
  description = "EFS access point ID"
  type        = string
  default     = null
}
