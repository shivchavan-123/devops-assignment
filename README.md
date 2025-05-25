# devops-assignment

For backend we are using aws S3 Bucket for state
Bucket name :-  shivdevopsassignmentdemo


Step 1: Network Setup
VPC: devops-assignment-vpc

2 Public Subnets (across 2 AZs)

2 Private Subnets (across 2 AZs)

Internet Gateway (for public subnets)

NAT Gateway (for private subnets)

Route tables and associations

Step 2: Load Balancer Setup
ALB Name: shiv-alb

Listener on port 80 (HTTP)

Target Group for ECS tasks

Step 3: ECS Setup
ECS Cluster :- shiv-cluster"

Task Definition with Docker image :- 222634373323.dkr.ecr.us-east-1.amazonaws.com/shivdemorepo:latest"

ECS Service connected to ALB target group

Step 4: Application Access
Access the app using ALB DNS Name :- arn:aws:elasticloadbalancing:us-east-1:222634373323:loadbalancer/app/shiv-alb/deeecafc54376aa2