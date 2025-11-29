resource "aws_security_group" "allow_tls" {
  name        = "SG_${var.project_name}"
  description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG_${var.project_name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_outbound"
  }
}