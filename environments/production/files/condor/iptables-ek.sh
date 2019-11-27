
#!/bin/bash
echo "Loading iptables rules"

NET_JINR="159.93.0.0/16"
NET_WN="10.93.220/22"

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t filter -F
iptables -t filter -X

iptables -F -t raw

iptables -P INPUT DROP

iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
echo "loopback allowed..."
iptables -A INPUT -i lo -j ACCEPT # А на выход вообще всё везде открыто

#Table mangle

iptables -t mangle -A PREROUTING -j ACCEPT
iptables -t mangle -A INPUT      -j ACCEPT
iptables -t mangle -A FORWARD    -j ACCEPT
iptables -t mangle -A OUTPUT     -j ACCEPT

iptables -t mangle -A POSTROUTING -j ACCEPT

iptables -t filter -A INPUT -s $NET_JINR -j ACCEPT
iptables -t filter -A INPUT -s $NET_WN -j ACCEPT
#+++++++++++++++++++++++ GRID special rules ++++++++++++++++++++++++++++++++++++++++++++++++++++


#-A INPUT -s 159.93.0.0/16 -p tcp -m tcp --dport 80 -j ACCEPT
#-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

iptables -t filter -A INPUT -s $NET_WN -p udp -m multiport --dports 22,111,662,875,892,2049,32769 -j ACCEPT
iptables -t filter -A INPUT -s $NET_WN -p tcp -m multiport --dports 22,111,662,875,892,2049,32803 -j ACCEPT


#-A INPUT -s 159.93.40.78/32 -p tcp -m tcp --dport 3001 -j ACCEPT
#-A INPUT -s 159.93.40.78/32 -p tcp -m tcp --dport 3000 -j ACCEPT
#-A INPUT -s 159.93.40.78/32 -p tcp -m tcp --dport 80 -j ACCEPT
#-A INPUT -s 159.93.40.78/32 -p tcp -m tcp --dport 443 -j ACCEPT
#-A INPUT -s 159.93.40.78/32 -p tcp -m tcp --dport 3306 -j ACCEPT

iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p icmp -j ACCEPT

iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited

iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited


sleep 1

iptables-save > /etc/sysconfig/iptables

