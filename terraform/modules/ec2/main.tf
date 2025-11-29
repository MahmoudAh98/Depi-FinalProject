# Data source for latest Amazon Linux 2023 AMI
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

# EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  instance_type          = var.instance_type

  tags = {
    Name = "EC2_${var.project_name}"
  }

  # Create directory for k8s manifests
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/k8s"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file(var.private_key_path)
    }
  }

  # Copy k8s manifests to EC2
  provisioner "file" {
    source      = var.k8s_manifests_path
    destination = "/home/ec2-user/k8s"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file(var.private_key_path)
    }
  }
}