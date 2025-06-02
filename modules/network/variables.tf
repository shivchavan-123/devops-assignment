variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (Development, Testing, Staging, Production)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
