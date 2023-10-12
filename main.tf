provider "aws" {
  region = "ap-southeast-2" # for Asia Pacific (Sydney) region on AWS
}

resource "aws_instance" "nginx_instance" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI ID (ap-southeast-2)
  instance_type = "t3.micro"              # The best performance instace type for (Asia Pacific - Sydney) region on AWS

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1.12 -y
              sudo service nginx start
              sudo chkconfig nginx on
              echo "Hello from Nginx on AWS EC2!" | sudo tee /usr/share/nginx/html/index.html
              EOF
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Security group for Nginx instance"

  ingress {
    from_port   = 80
    to_port     = 80
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

output "nginx_public_ip" {
  value = aws_instance.nginx_instance.public_ip
}
