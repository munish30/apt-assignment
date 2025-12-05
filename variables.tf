# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Tier = "Private"
#   }
# }

# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Tier = "Public"
#   }
# }

locals {
  cidr_range      = "10.16.0.0/16"
  subnets         = [for cidr in range(8) : cidrsubnet(local.cidr_range, 5, cidr)]
  public_subnets  = slice(local.subnets, 0, 2)
  private_subnets = slice(local.subnets, 2, 4)
}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type = list(string)
}

