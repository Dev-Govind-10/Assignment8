variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_ids" {
    type = list(string)
  default = ["subnet-0c89f893a0a8c23ba"]
}
variable "vpc_id" {
  default = "vpc-06e64940821e06cdb"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ecs_cluster_name" {
  default = "app-ecs-cluster"
}

variable "backend_container_port" {
  default = 8000
}

variable "frontend_container_port" {
  default = 3000
}

variable "desired_count" {
  type    = number
  default = 1
}

# Use image tags or "latest"
variable "backend_image_tag" { default = "latest" }
variable "frontend_image_tag" { default = "latest" }
