# Key Pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "tws-terra-key"
  public_key = file("F:/Multi-env AWS Infra/terra-key.pub")
}

# Default VPC
resource "aws_default_vpc" "default_vpc" {}

# Security Group
resource "aws_security_group" "tws_security" {
  name        = "allow-ports"
  description = "This SG is for EC2 instance"
  vpc_id      = aws_default_vpc.default_vpc.id

  # Ingress Rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress Rules
  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysecurity"
  }
}

# Fetch Latest Ubuntu AMI
data "aws_ami" "os_image" {
  owners      = ["099720109477"] # Canonical (Ubuntu)
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }
}

# EC2 Instance
resource "aws_instance" "test_instance" {
  ami           = data.aws_ami.os_image.id
  instance_type =  var.instance_type
  key_name      = aws_key_pair.ec2_key_pair.key_name

  security_groups = [aws_security_group.tws_security.name]

  tags = {
    Name = "Terra-Automate"
  }

  # Root Block Device
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}
