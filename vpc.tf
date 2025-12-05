module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "apt-vpc"
  cidr = local.cidr_range

  azs             = var.availability_zones
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  create_igw = true


  public_subnet_tags = {
    Tier = "Public"
  }

  private_subnet_tags = {
    Tier = "Private"
  }

  default_security_group_egress = [
    {
      description = "Allow HTTPS for SSM"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  default_security_group_ingress = [
    {
      description = "Allow HTTP for server"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "10.16.0.0/16"
    }
  ]

  tags = {
    Terraform = "true"
  }
}

