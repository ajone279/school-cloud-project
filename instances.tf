
data "aws_ssm_parameter" "windows_ami" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base"
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

locals {
  windows_servers = {
    DC01  = "Domain Controller 1"
    DC02  = "Domain Controller 2"
    CA01  = "Microsoft Certificate Authority"
    NPS01 = "Network Policy Server"
  }

  linux_servers = {
    Linux01 = {
      subnet    = "external"
      public_ip = true
    }
    Linux02 = {
      subnet    = "external"
      public_ip = true
    }
    Linux03 = {
      subnet    = "internal"
      public_ip = false
    }
    Linux04 = {
      subnet    = "internal"
      public_ip = false
    }
  }
}

resource "aws_instance" "windows" {
  for_each = local.windows_servers

  ami                    = data.aws_ssm_parameter.windows_ami.value
  instance_type          = var.windows_instance_type
  subnet_id              = aws_subnet.internal.id
  vpc_security_group_ids = [aws_security_group.windows.id]
  key_name               = aws_key_pair.school_key.key_name

  tags = {
    Name    = each.key
    Role    = each.value
    Project = var.project_name
  }
}

resource "aws_instance" "linux" {
  for_each = local.linux_servers

  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.linux_instance_type
  subnet_id                   = each.value.subnet == "external" ? aws_subnet.external.id : aws_subnet.internal.id
  vpc_security_group_ids      = [aws_security_group.linux.id]
  key_name                    = aws_key_pair.school_key.key_name
  associate_public_ip_address = each.value.public_ip

  tags = {
    Name    = each.key
    Role    = "Linux Server"
    Project = var.project_name
  }
}
