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





