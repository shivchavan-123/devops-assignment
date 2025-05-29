# Production Environment Variables
environment = "prod"
vpc_cidr = "10.2.0.0/16"

# Subnet CIDRs
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]

# ECS Configuration
ecs_cluster_name = "shiv-cluster-prod"
ecs_service_name = "shiv-service-prod"
ecs_task_family = "shiv-task-prod"
ecs_desired_count = 3
ecs_cpu = 1024
ecs_memory = 2048

# ALB Configuration
alb_name = "shiv-alb-prod"
target_group_name = "shiv-tg-prod"

# VPC Name
vpc_name = "devops-assignment-vpc-prod"

# Tags
common_tags = {
  Environment = "prod"
  Project     = "devops-assignment"
  ManagedBy   = "terraform"
  Owner       = "shiv"
}
