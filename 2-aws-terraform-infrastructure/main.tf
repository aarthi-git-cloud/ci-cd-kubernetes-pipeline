# Root module — wires all modules together

module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  project_name        = var.project_name
  environment         = var.environment
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  key_name            = var.key_name
  private_subnet_ids  = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  iam_instance_profile = module.iam.instance_profile_name
}

module "alb" {
  source = "./modules/alb"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name         = var.project_name
  environment          = var.environment
  launch_template_id   = module.ec2.launch_template_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  target_group_arn     = module.alb.target_group_arn
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
}
