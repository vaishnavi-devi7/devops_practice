
# Variable Definition
variable "ami-referrence" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99" 
}

# EC2 Instance
resource "aws_instance" "testec2" {
  ami           = var.ami-referrence
  subnet_id     = aws_subnet.pub-sub.id
  instance_type = "t2.micro" # AWS Free Tier eligible instance type
  key_name      = "webserver key" # Updated key name

  vpc_security_group_ids = [aws_security_group.learn_sg.id]

  tags = {
    Name = "demoinstance"
    team = "sjece-devops"
  }
}

# Security Group
resource "aws_security_group" "learn_sg" {
  name        = "learn-sg"
  description = "Allow SSH (22), HTTP (80), and HTTPS (443) inbound traffic"
  vpc_id      = aws_vpc.demovpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "learn-sg"
    team = "sjece-devops"
  }
}