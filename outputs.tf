output "vpc_id" {
  value = aws_vpc.school_vpc.id
}

output "external_subnet_id" {
  value = aws_subnet.external.id
}

output "internal_subnet_id" {
  value = aws_subnet.internal.id
}

output "firewall_public_ip" {
  value = aws_eip.firewall.public_ip
}

output "windows_instance_private_ips" {
  value = {
    for name, instance in aws_instance.windows :
    name => instance.private_ip
  }
}

output "linux_instance_private_ips" {
  value = {
    for name, instance in aws_instance.linux :
    name => instance.private_ip
  }
}
