provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/config"
}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2" {
  source               = "./ec2"
  my_public_key        = "./public"
  instances_type       = "t2.micro"
  security_group       = module.vpc.security_group
  subnets              = module.vpc.public_subnets
  ami                  = "ami-00cb4c0d60b9476f4"
}
/*
 module "alb" {
  source       = "./alb"
  vpc_id       = module.vpc.aws_vpc_id
  instance1_id = module.ec2.instance1_id
  instance2_id = module.ec2.instance2_id
  subnet1      = module.vpc.subnet1
  subnet2      = module.vpc.subnet2
}

 module "rds" {
  source      = "./rds"
  db_instance = "db.t2.micro"
  rds_subnet1 = module.vpc.private_subnet1
  rds_subnet2 = module.vpc.private_subnet2
  vpc_id      = module.vpc.aws_vpc_id
}
*/