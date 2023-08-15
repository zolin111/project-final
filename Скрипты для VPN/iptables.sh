eth0=$1
proto=$2
port=$3
# OpenVPN
iptables -A INPUT -i "$eth0" -m state --state NEW -p "$proto" --dport "$port" -j ACCEPT
# Allow TUN interface connections to OpenVPN server
iptables -A INPUT -i tun+ -j ACCEPT
# Allow TUN interface connections to be forwarded throuqh other interface
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -o "$eth0" -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i "$eth0" -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
# NAT the VPN client traffic to the internet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$eth0" -j MASQUERADE


