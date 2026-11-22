resource "aws_instance" "firewall" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.external.id
  vpc_security_group_ids      = [aws_security_group.firewall.id]
  key_name                    = aws_key_pair.school_key.key_name
  associate_public_ip_address = false
  source_dest_check           = false
  user_data                   = file("${path.module}/firewall-setup.sh")

  tags = {
    Name    = "School-VPN-Firewall"
    Role    = "IPsec VPN Firewall"
    Project = var.project_name
  }
}

resource "aws_eip" "firewall" {
  domain = "vpc"

  tags = {
    Name    = "School-VPN-Firewall-EIP"
    Project = var.project_name
  }
}

resource "aws_eip_association" "firewall" {
  allocation_id = aws_eip.firewall.id
  instance_id   = aws_instance.firewall.id
}
