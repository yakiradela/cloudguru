provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./modules/vpc"
  public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-2a", "us-east-2b"]
}

module "ecs" {
  source          = "./modules/ecs"
  cluster_name    = "my-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "bastion" {
  source           = "./modules/bastion"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets
  allowed_ip       = var.allowed_ip
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "secrets" {
  source = "./modules/secrets"
  secrets = {
    DB_PASSWORD = "s3cr3t123"
    API_KEY     = "xyz-abc-123"
  }
}

module "iam" {
  source = "./modules/iam"
}
resource "aws_ecs_task_definition" "my_service_task" {
  family                   = "my-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "my-service"
      image     = "557690607676.dkr.ecr.us-east-2.amazonaws.com/backend:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "ENV"
          value = "production"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = module.ecs.cluster_id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.my_service_task.arn

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [module.ecs.service_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "my-service"
    container_port   = 80
  }

  depends_on = [module.alb.alb_listener]
}



