# Initialize provider (pass credentials as env. variables or -var on cli)
provider "aws" {
  # access_key = var.AWS_ACCESS_KEY
  # secret_key = var.AWS_SECRET_KEY
  region = var.AWS_REGION 
}

# Calling VPC Module from public Terraform registry 
module "eks_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.ENVIRONMENT}-eks-vpc"
  cidr = "172.16.0.0/16"

  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b"]
  private_subnets = ["172.16.21.0/24", "172.16.22.0/24"]
  public_subnets  = ["172.16.23.0/24", "172.16.24.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false 
  map_public_ip_on_launch = true 

  tags = {
    Environment = "${var.ENVIRONMENT}"
  }
}