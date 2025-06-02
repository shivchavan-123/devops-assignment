# Development Environment Variables
environment = "dev"
vpc_cidr = "10.0.0.0/16"

# Subnet CIDRs
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
# ECS Configuration
ecs_cluster_name = "shiv-cluster-dev"
ecs_service_name = "shiv-service-dev"
ecs_task_family = "shiv-task-dev"
ecs_desired_count = 1
ecs_cpu = 256
ecs_memory = 512

# ALB Configuration
alb_name = "shiv-alb-dev"
target_group_name = "shiv-tg-dev"

# VPC Name
vpc_name = "devops-assignment-vpc-dev"

# Tags
common_tags = {
  Environment = "dev"
  Project     = "devops-assignment"
  ManagedBy   = "terraform"
  Owner       = "shiv"
}
