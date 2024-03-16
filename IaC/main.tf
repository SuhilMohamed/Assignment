# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.app_vpc.id
}

# Create a public subnet for the application instance
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Replace with your desired availability zone

  # Enable auto-assign public IP addresses
  map_public_ip_on_launch = true
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
}

# Create a route to the internet gateway
resource "aws_route" "public_route" {
  route_table_id  = aws_route_table.public_route_table.id
  cidr_block      = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.gw.id
}

# Attach the public route table to the public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id  = aws_route_table.public_route_table.id
}

# Create a security group for the application instance allowing inbound HTTP traffic
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere for simplicity (adjust for production)
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an IAM role for the application instance with basic S3 access
resource "aws_iam_role" "app_role" {
  name = "app-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "app_role_s3_access" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create an RDS instance for data storage
resource "aws_rds_cluster" "db_cluster" {
  engine         = "mysql"
  engine_version = "8.0"
  master_username = "appuser"
  master_password = "your_strong_password"
  database_name  = "app_db"
  allocated_storage = 20

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Create a DB subnet group with the public subnet
  db_subnet_group_name = "db-subnet-group"

  db_subnet_group {
    subnet_identifier = aws_subnet.public_subnet.id
  }
}

# Create an EC2 instance for the application
resource "aws_instance" "app_instance" {
  ami           = "ami-01234567890abcdef0"  
