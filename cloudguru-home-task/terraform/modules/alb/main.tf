variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)  
}

variable "target_group_name" {
    default             = "ecs-tg" 
}  

resource "aws_security_group" "alb_sg" {
    name                = "alb-sg"
    description         = "Allow HTTP"
    vpc_id              = var.vpc_id 

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]  
    }   
}

resource "aws_lb" "app_alb" {
    name                = "app-alb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.alb_sg.id]
    subnets             = var.public_subnets    
}

resource "aws_lb_target_group" "ecs_tg" {
    name                = var.target_group_name
    port                = 80
    protocol            = "HTTP"
    vpc_id              = var.vpc_id
    target_type         = "ip"    
}

resource "aws_lb_listener" "http" {
  load_balancer_arn     = aws_lb.app_alb.arn
  port                  = 80
  protocol              = "HTTP"

  default_action {
    type                = "fixed-response"
    fixed_response {
        content_type    = "text/plain"
        message_body    = "Service not available yet"
        status_code     = "200"   
      
    } 
  }
}

output "alb_dns" {
    value               = aws_lb.app_alb.dns_name       
}

output  "alb_target_group_arn" {
    value = aws_lb_target_group.ecs_tg.arn     
}
