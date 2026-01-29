output "alb_arn" {
  description = "ARN del ALB"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name del ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID del ALB"
  value       = aws_lb.main.zone_id
}

output "target_group_arns" {
  description = "ARNs de los target groups"
  value       = { for k, v in aws_lb_target_group.services : k => v.arn }
}

output "https_listener_arn" {
  description = "ARN del listener HTTPS"
  value       = aws_lb_listener.https.arn
}

output "alb_arn_suffix" {
  description = "Sufijo del ARN del ALB"
  value       = aws_lb.main.arn_suffix
}
