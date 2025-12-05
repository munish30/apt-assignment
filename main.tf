


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "apt-asg"

  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets


  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 66
      max_healthy_percentage = 100
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "apt-asg-lt"
  launch_template_description = "Default launch template for apt assignment"
  update_default_version      = true
  user_data = base64encode(file("./scripts/user_data.sh"))
  image_id          = data.aws_ami.amazon_linux_2.image_id
  instance_type     = var.instance_type
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "apt-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for apt autoscaling group instances"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [ aws_default_security_group.default.id ]
    },
    {
      delete_on_termination = true
      description           = "eth1"
      device_index          = 1
      security_groups       = [ aws_default_security_group.default.id ]
    }
  ]

  min_elb_capacity = 1

  tags = {
    Environment = "dev"
  }
}

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

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = module.asg.autoscaling_group_name
  lb_target_group_arn = module.alb.target_groups["apt_app"].arn
}