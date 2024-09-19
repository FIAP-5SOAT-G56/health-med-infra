# Naming
variable "environment" {
  default = "studying"
}

variable "resource_prefix" {
  default = "fiap-health-med"
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "default_az" {
  default = "us-east-1a"
}

# Outputs for variables
output "environment" {
  value = var.environment
}

output "resource_prefix" {
  value = var.resource_prefix
}

output "region" {
  value = var.region
}

output "availability_zones" {
  value = var.availability_zones
}

output "default_az" {
  value = var.default_az
}

# RDS
variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_engine" {
  default = "mysql"
}

variable "db_engine_version" {
  default = "5.7"
}

variable "db_parameter_group_name" {
  default = "default.mysql5.7"
}

variable "db_name" {
  default = "health-med"
}

variable "cache_engine" {
  default = "redis"
}

variable "cache_node_type" {
  default = "cache.t3.micro"
}

# Secrets
variable "DB_USERNAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

