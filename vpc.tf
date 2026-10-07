# VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpcterra"
  }
}

# Private Subnet
resource "aws_subnet" "pri-sub" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private subnet"
  }
}

# Public Subnet
resource "aws_subnet" "pub-sub" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true # Automatically gives EC2 a public IP

  tags = {
    Name = "public subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demovpc.id

  tags = {
    Name = "igwterra"
  }
}

# Route Table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "routeterra"
  }
}

# Route Table Association
resource "aws_route_table_association" "route-asso" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.route.id
}

# EC2 Instance
resource "aws_instance" "testec2" {
  ami           = "ami-0b6d9d3d33ba97d99" # Ensure this AMI is correct for your region
  subnet_id     = aws_subnet.pub-sub.id
  instance_type = "t3.micro"
  key_name      = "ec2key" # You must have an SSH key pair named 'ec2key' in AWS

  # Attaches the dynamically created security group below
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "demoinstance"
    team = "sjc-devops"
  }
}

# Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS, SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demovpc.id

  # Allow SSH to access the server
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow server to connect to the internet (download packages, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group"
  }
}