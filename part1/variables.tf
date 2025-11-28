variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI"
  default     = "ami-02b8269d5e85954ef" # Update with latest Ubuntu AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "backend_port" {
  default = 8000
}

variable "ssh_public_key" {
  description = "Path to public SSH key"
  default     = "C:/Users/GovindPrajapati/.ssh/id_rsa.pub"
}
