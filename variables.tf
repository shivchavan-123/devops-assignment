variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Development"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "DevOpsAssignment"
}
