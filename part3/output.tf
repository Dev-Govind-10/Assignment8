# output "account_id" {
#   value = data.aws_caller_identity.me.account_id
# }

# output "alb_dns" {
#   value = aws_lb.alb.dns_name
# }

# output "backend_ecr_repo" {
#   value = aws_ecr_repository.backend.repository_url
# }

# output "frontend_ecr_repo" {
#   value = aws_ecr_repository.frontend.repository_url
# }

output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "frontend_url" {
  value = "http://${aws_lb.alb.dns_name}:3000"
}

output "backend_url" {
  value = "http://${aws_lb.alb.dns_name}:8000"
}

output "ecr_backend_repo" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repo" {
  value = aws_ecr_repository.frontend.repository_url
}

