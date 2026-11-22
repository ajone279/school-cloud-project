resource "aws_route" "internal_internet" {
  route_table_id         = aws_route_table.internal.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.firewall.primary_network_interface_id
}

resource "aws_route" "internal_school_network" {
  route_table_id         = aws_route_table.internal.id
  destination_cidr_block = var.school_network_cidr
  network_interface_id   = aws_instance.firewall.primary_network_interface_id
}
