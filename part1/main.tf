terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#############################
# VPC + Subnet + IGW + Route
#############################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#############################
# Key Pair
#############################

resource "aws_key_pair" "app_key" {
  key_name   = "app-key"
  public_key = file(var.ssh_public_key)
}

#############################
# Security Groups
#############################

resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id
  name   = "frontend-sg"

  ingress {
    description = "Allow HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# BACKEND SG (only allow frontend to connect)
# resource "aws_security_group" "backend_sg" {
#   vpc_id = aws_vpc.main.id
#   name   = "backend-sg"

#   ingress {
#     description    = "Allow API traffic from frontend"
#     from_port       = var.backend_port
#     to_port         = var.backend_port
#     protocol        = "tcp"
#     security_groups = [aws_security_group.frontend_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

#############################
# EC2 INSTANCES
#############################

# # FRONTEND EC2
resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = aws_key_pair.app_key.key_name


  # Copy BACKEND folder
  provisioner "file" {
    source      = "backend"
    destination = "/home/ubuntu/backend"
  }

  # Copy FRONTEND folder
  provisioner "file" {
    source      = "frontend"
    destination = "/home/ubuntu/frontend"
  }

  # Commands to RUN AFTER upload
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y python3-full python3-pip nodejs npm nginx -y",
      "sudo apt install -y python3-flask",

      # Install PM2 globally
      "sudo npm install -g pm2",

      # Backend (Flask)
      "cd /home/ubuntu/backend && pip3 install -r requirements.txt",
      "pm2 start app.py --name backend --interpreter python3",

      # Frontend (Express or Node-based frontend)
      "cd /home/ubuntu/frontend && npm install",
      "pm2 start app.js --name frontend",

      # Enable PM2 startup so apps run on reboot
      "pm2 startup systemd",
      "pm2 save"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/GovindPrajapati/.ssh/id_rsa")
    host        = self.public_ip
  }

  tags = {
    Name = "frontend-backend-server"
  }

#   user_data = <<EOF
# #!/bin/bash
# sudo apt update -y
# sudo apt install nginx -y

# # Place frontend build files
# sudo mkdir -p /var/www/frontend
# echo "Frontend Running Successfully" > /var/www/frontend/index.html

# sudo rm -rf /var/www/html
# sudo ln -s /var/www/frontend /var/www/html

# sudo systemctl enable nginx
# sudo systemctl restart nginx
# EOF
}

# # BACKEND EC2
# resource "aws_instance" "backend" {
#   ami                    = var.ami_id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnet.id
#   vpc_security_group_ids = [aws_security_group.backend_sg.id]
#   key_name               = aws_key_pair.app_key.key_name

#   tags = {
#     Name = "backend-server"
#   }

#   user_data = <<EOF
# #!/bin/bash
# sudo apt update -y
# sudo apt install -y nodejs npm

# mkdir /home/ubuntu/backend-app
# cat <<EOT > /home/ubuntu/backend-app/server.js
# const express = require("express");
# const app = express();
# app.get("/api", (req,res)=>res.send("Backend API Running"));
# app.listen(${var.backend_port}, ()=>console.log("API Running"));
# EOT

# cd /home/ubuntu/backend-app
# npm init -y
# npm install express

# nohup node server.js > app.log 2>&1 &
# EOF
# }
