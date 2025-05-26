variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "image_url" {
  type        = string
  description = "Docker image URL (ECR)"
}

variable "cpu" {
  type        = string
  description = "CPU units for the ECS task"
  default     = "256"
}

variable "memory" {
  type        = string
  description = "Memory for the ECS task"
  default     = "512"
}

variable "container_port" {
  type        = number
  description = "Container port to expose"
  default     = 80
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks"
  default     = 1
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for ECS tasks"
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN"
}

variable "log_group" {
  type        = string
  description = "CloudWatch log group name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment name (Development, Testing, Staging, Production)"
}

variable "project" {
  type        = string
  description = "Project name or identifier"
}
