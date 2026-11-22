variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "project_name" {
  type    = string
  default = "school-cloud-project"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "external_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "internal_subnet_cidr" {
  type    = string
  default = "10.20.10.0/24"
}

variable "school_network_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "linux_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "windows_instance_type" {
  type    = string
  default = "c6i.xlarge"
}

variable "admin_cidr" {
  type    = string
  default = "203.0.113.20/32"
}

variable "school_vpn_peer_cidr" {
  type    = string
  default = "203.0.113.10/32"
}