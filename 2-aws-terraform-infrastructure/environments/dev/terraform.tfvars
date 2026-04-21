project_name = "myapp"
environment  = "dev"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

instance_type = "t3.small"      # Smaller instance for dev (cost saving)
ami_id        = "ami-0c02fb55956c7d316"   # Amazon Linux 2
key_name      = "myapp-dev-key"

asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 1
