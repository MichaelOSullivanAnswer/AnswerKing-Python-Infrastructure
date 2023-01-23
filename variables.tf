variable "aws_region" {
    type = string
    description = "AWS Region to use for resources"
    default = "eu-west-2"
}

variable "project_name" {
  description = "Project name to use in resource names"
  default     = "ak-python"
}

variable "availability_zones" {
  description = "Availability zones"
  default     = ["eu-west-2", "eu-west-1"]
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_cidr_blocks" {
  description = "CIDR Blocks for Subnets in VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

