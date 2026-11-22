#!/bin/bash
set -e

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
  strongswan \
  iptables \
  iptables-persistent

WAN_INTERFACE=$(ip route show default | awk '{print $5; exit}')

cat > /etc/sysctl.d/99-school-firewall.conf <<'EOF'
net.ipv4.ip_forward=1
EOF

sysctl --system

iptables -t nat -C POSTROUTING -s 10.20.0.0/16 -o "$WAN_INTERFACE" -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 10.20.0.0/16 -o "$WAN_INTERFACE" -j MASQUERADE

iptables -C FORWARD -s 10.20.0.0/16 -o "$WAN_INTERFACE" -j ACCEPT 2>/dev/null || \
iptables -A FORWARD -s 10.20.0.0/16 -o "$WAN_INTERFACE" -j ACCEPT

iptables -C FORWARD -d 10.20.0.0/16 -m conntrack --ctstate ESTABLISHED,RELATED -i "$WAN_INTERFACE" -j ACCEPT 2>/dev/null || \
iptables -A FORWARD -d 10.20.0.0/16 -m conntrack --ctstate ESTABLISHED,RELATED -i "$WAN_INTERFACE" -j ACCEPT

netfilter-persistent save

systemctl enable strongswan-starter
