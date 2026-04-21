# AWS Infrastructure as Code — Terraform

Production-ready AWS infrastructure built with reusable Terraform modules. Provisions a complete VPC, EC2 auto-scaling group, Application Load Balancer, S3 storage, and IAM roles — following AWS Well-Architected Framework principles.

---

## Architecture Overview

```
                        Internet
                           │
                     [Route 53 DNS]
                           │
                    [ALB - Public]
                    /             \
          [Public Subnet AZ-a]  [Public Subnet AZ-b]
                    │                    │
          [Private Subnet AZ-a] [Private Subnet AZ-b]
                    │                    │
             [EC2 Auto Scaling Group — App Tier]
                           │
                     [RDS / S3 — Data Tier]
                           │
                     [NAT Gateway]
                           │
                        Internet
```

---

## Module Structure

```
aws-terraform-infrastructure/
├── main.tf                   # Root module — wires everything together
├── variables.tf              # Input variables
├── outputs.tf                # Output values (ALB DNS, VPC ID, etc.)
├── versions.tf               # Terraform & provider version locks
├── modules/
│   ├── vpc/                  # VPC, subnets, route tables, IGW, NAT
│   ├── ec2/                  # EC2 launch template + key pair
│   ├── alb/                  # Application Load Balancer + target group
│   ├── autoscaling/          # Auto Scaling Group + scaling policies
│   ├── s3/                   # S3 bucket with versioning + encryption
│   └── iam/                  # IAM roles and instance profiles
└── environments/
    ├── dev/                  # Dev environment tfvars
    └── prod/                 # Prod environment tfvars
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| Terraform | Infrastructure as Code |
| AWS VPC | Network isolation |
| AWS EC2 + ASG | Compute + auto scaling |
| AWS ALB | Load balancing |
| AWS S3 | Object storage |
| AWS IAM | Least-privilege access |

---

## Key Features

- **Reusable modules** — each module is self-contained and reusable across environments
- **Multi-AZ deployment** — resources spread across 2 availability zones for high availability
- **Least privilege IAM** — EC2 instances only get the permissions they need
- **S3 encryption** — all buckets encrypted at rest using AWS KMS
- **Remote state** — Terraform state stored in S3 with DynamoDB locking
- **Environment separation** — dev and prod use the same modules with different variable values

---

## How to Deploy

### Prerequisites
- Terraform >= 1.3.0
- AWS CLI configured with appropriate credentials
- S3 bucket for remote state (update `versions.tf`)

### Deploy Dev Environment
```bash
cd environments/dev
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Deploy Prod Environment
```bash
cd environments/prod
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Destroy (cleanup)
```bash
terraform destroy
```

---

## Key Results
- Reduced manual infrastructure provisioning time by **60%**
- Consistent, repeatable deployments across dev and prod with zero config drift
- Full infrastructure rebuilt from scratch in under **10 minutes**

---

## Lessons Learned
- Always use remote state with locking — local state causes team conflicts
- Separate modules per resource type — makes troubleshooting much faster
- `terraform plan` output should be reviewed like a code PR before applying
