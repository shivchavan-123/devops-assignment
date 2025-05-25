variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security groups associated with ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port the target group will forward to"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/healthz"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
