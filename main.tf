provider "aws" {
  region = var.aws_region

}


terraform {
    backend "s3" {
    bucket         = "shivdevopsassignmentdemo"     
    key            = "dev/terraform.tfstate"    
    region         = "us-east-1"                
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Development"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "DevOpsAssignment"
}

# Add CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/hello-app"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "vpc" {
  source = "./modules/network"

  project              = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}


module "ecs" {
  source = "./modules/ecs"

  cluster_name      = "shiv-cluster"
  app_name          = "hello-app"
  image_url         = "222634373323.dkr.ecr.us-east-1.amazonaws.com/shivdemorepo:latest"
  cpu               = "256"
  memory            = "512"
  container_port    = 80
  desired_count     = 1
  environment       = var.environment
  project           = var.project_name

  private_subnets   = module.vpc.private_subnet_ids
  security_group_ids = [module.ecs_sg.security_group_id]

  target_group_arn  = module.alb.target_group_arn
  log_group         = "/ecs/hello-app"
  region            = "us-east-1"

  depends_on = [aws_cloudwatch_log_group.ecs_logs]
}

module "alb" {
  source               = "./modules/alb"

  alb_name             = "shiv-alb"
  internal             = false
  security_group_ids   = [module.alb_sg.security_group_id]
  subnet_ids           = module.vpc.public_subnet_ids

  target_group_name    = "shiv-tg"
  target_group_port    = 80
  target_group_protocol = "HTTP"
  health_check_path    = "/healthz"
  vpc_id               = module.vpc.vpc_id
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}



module "app_security_group" {
  source      = "./modules/security_group"
  name        = "app-sg"
  description = "Security group for ECS app"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name        = "AppSecurityGroup"
    Environment = "dev"
  }
}


module "alb_sg" {
  source      = "./modules/security_group"
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name = "ALB-SG"
  }
}


module "ecs_sg" {
  source      = "./modules/security_group"
  name        = "ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      security_group = [module.alb_sg.security_group_id]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name = "ECS-SG"
  }
}

