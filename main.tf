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

# Remove these variable declarations from main.tf since they're in variables.tf
# variable "environment" { ... }  <- DELETE THIS
# variable "project" { ... } <- DELETE THIS

# Add CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/hello-app"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

module "vpc" {
  source = "./modules/network"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name      = "shiv-cluster"
  app_name          = "hello-app"
  image_uri             = var.image_uri
  cpu               = "256"
  memory            = "512"
  container_port    = 80
  desired_count     = 1
  environment       = var.environment
  project       = var.project
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
    Project     = var.project
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
    Environment = var.environment
    Project     = var.project
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
    Name        = "ALB-SG"
    Environment = var.environment
    Project     = var.project
  }
}

module "ecs_sg" {
  source      = "./modules/security_group"
  name        = "ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.alb_sg.security_group_id]
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
    Name        = "ECS-SG"
    Environment = var.environment
    Project     = var.project
  }
}


#done and dusted