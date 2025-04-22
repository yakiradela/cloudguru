variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = list(string)
}

variable "allowed_ip" {
  description = "The IP address allowed to access the bastion host"
  type        = string
}


resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "bastion" {
  ami                    = "ami-04f167a56786e4b09" 
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}
