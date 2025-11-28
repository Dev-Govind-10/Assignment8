output "frontend_public_ip" {
  value = "http://${aws_instance.instance.public_ip}:3000"
}

output "backend_public_ip" {
  value = "http://${aws_instance.instance.public_ip}:8000/view"
}

