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
   key_name       = "mahmoud"

  instance_type = "t3.micro"
  tags = {
    Name = "EC2_EKS"
  }


provisioner "remote-exec" {
  inline = [
    "mkdir -p /home/ec2-user/k8s"
  ]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("../script/mahmoud.pem")
  }
}


  provisioner "file" {
    source      = "../k8s/"  
    destination = "/home/ec2-user/k8s"

    connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("../script/mahmoud.pem")
        }
  }


    depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.nodes
  ]
}

