# provider and version initiation

terraform {
    backend "s3" {
        bucket = "lab6-terraform-backend-bucket-188684347704-eu-north-1-an"
        key    = "terraform.tfstate"
        region = "eu-north-1"
    }
    
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "eu-north-1"
}

# Security Group
resource "aws_security_group" "web_sg" {
    name        = "web-security-group"
    description = "Allow HTTP and SSH"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
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

# EC2 Instance
resource "aws_instance" "web" {
    ami           = "ami-073130f74f5ffb161"
    instance_type = "t3.micro"

    vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name = "Lab4-KeyPair"

    user_data = <<-EOF
          #!/bin/bash
          apt update
          apt install -y docker.io
          systemctl start docker
          systemctl enable docker
          docker run -d -p 80:80 --restart always bodyayast/brigade-3-site-l5
          docker run -d --restart always \
            --name watchtower \
            -v /var/run/docker.sock:/var/run/docker.sock \
            containrrr/watchtower --interval 30
          EOF


    tags = {
        Name = "lab-6-instance"
    }
}

output "instance_public_ip" {
    description = "Public Server IP"
    value = aws_instance.web.public_ip
}