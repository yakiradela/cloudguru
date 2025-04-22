# משתנים
variable "vpc_id" {
  description = "The ID of the VPC where the ECS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

# יצירת הקלאסטר
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# Outputs
output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}
