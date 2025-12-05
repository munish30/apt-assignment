module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "apt-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all_http = {
      cidr_ipv4   = "10.16.0.0/16"
      from_port = 8080
      to_port   = 8080
      ip_protocol = "tcp"
    }
  }

  # access_logs = {
  #   bucket = "my-alb-logs"
  # }

  listeners = {
    apt-app = {
      port     = 80
      protocol = "HTTP"

      forward = {
        # type             = "forward"
        target_group_key = "apt_app"
      }
    }
  }

  target_groups = {
    apt_app = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 8080
      target_type = "instance"
      health_check = {
        path = "/health"
        port = "8080"
      }
      create_attachment = false
    }
  }

  enable_deletion_protection = false

}
