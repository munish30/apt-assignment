output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "Public DNS name of the ALB"
}
