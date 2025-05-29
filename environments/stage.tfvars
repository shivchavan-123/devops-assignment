# Staging Environment Variables
environment = "staging"
vpc_cidr = "10.1.0.0/16"

# Subnet CIDRs
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

# ECS Configuration
ecs_cluster_name = "shiv-cluster-staging"
ecs_service_name = "shiv-service-staging"
ecs_task_family = "shiv-task-staging"
ecs_desired_count = 2
ecs_cpu = 512
ecs_memory = 1024

# ALB Configuration
alb_name = "shiv-alb-staging"
target_group_name = "shiv-tg-staging"

# VPC Name
vpc_name = "devops-assignment-vpc-staging"

# Tags
common_tags = {
  Environment = "staging"
  Project     = "devops-assignment"
  ManagedBy   = "terraform"
  Owner       = "shiv"
}
