data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.amazon.id
  subnet_id     = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.allow_tls.id]

  instance_type = "t3.micro"
  tags = {
    Name = "EC2_EKS"
  }
}