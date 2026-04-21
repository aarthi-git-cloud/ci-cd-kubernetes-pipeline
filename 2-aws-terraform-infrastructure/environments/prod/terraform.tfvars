project_name = "myapp"
environment  = "prod"

vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

instance_type = "t3.medium"     # Larger instance for prod workloads
ami_id        = "ami-0c02fb55956c7d316"   # Amazon Linux 2
key_name      = "myapp-prod-key"

asg_min_size         = 2        # Always keep 2 running in prod
asg_max_size         = 6
asg_desired_capacity = 2
