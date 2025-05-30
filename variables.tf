variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "DevOpsAssignment"
}

variable "image_uri" {
  description = "The ECR image URI built from CI pipeline"
  type        = string
}
