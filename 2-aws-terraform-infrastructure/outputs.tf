# Outputs — useful values printed after terraform apply

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer — use this to access the app"
  value       = module.alb.alb_dns_name
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.autoscaling.asg_name
}

output "s3_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.s3.bucket_name
}
