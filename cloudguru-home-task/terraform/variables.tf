variable "region" {
    description     = "The AWS region where resources will be created"
    type	    = string
    default         = "us-east-2"      
}

variable "allowed_ip" {
  description = "The IP address allowed to access the bastion host"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}
