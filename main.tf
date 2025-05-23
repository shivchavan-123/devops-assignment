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


module "vpc" {
  source = "./modules/network"

  project              = "devops-assignment"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

/* module "ecs" {
  source = "./modules/ecs"  # Adjust if module is elsewhere

  aws_region           = var.aws_region
  ecr_repo_url         = ""
  image_tag            = "latest"

  private_subnets         = module.vpc.private_subnets
  ecs_security_group_id   = aws_security_group.ecs_tasks_sg.id
  target_group_arn        = aws_lb_target_group.app_tg.arn
}
*/


