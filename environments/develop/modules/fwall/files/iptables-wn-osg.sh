#!/bin/bash
#Скрипт с правилами iptables применяемый на рабочих узлах NOvA
#
echo "Loading iptables rules"

NET_JINR="159.93.0.0/16"
NET_221="10.93.220.0/22" # Сеть серых ip для кластера grid nova work-nodes

#It's not a router so don't forward
#echo 1 > /proc/sys/net/ipv4/ip_forward

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
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "loopback allowed..."
iptables -A INPUT -i lo -m comment --comment "Allow all for loopback" -j ACCEPT # А на выход вообще всё везде открыто

#Table mangle

iptables -t mangle -A PREROUTING -j ACCEPT
iptables -t mangle -A INPUT      -j ACCEPT
iptables -t mangle -A FORWARD    -j ACCEPT
iptables -t mangle -A OUTPUT     -j ACCEPT

iptables -t mangle -A POSTROUTING -j ACCEPT


#Table filter


iptables -t filter -A INPUT -p tcp -m tcp --dport 22 -m comment --comment "Allow SSH" -j ACCEPT
iptables -t filter -A INPUT -s $NET_JINR -m comment --comment "Let all from JINR" -j ACCEPT
iptables -t filter -A INPUT -s $NET_221  -m comment --comment "Allow local 10.93.221.xxx cluster, though it's already fine" -j ACCEPT

#+++++++++++++++++++++++ GRID special rules ++++++++++++++++++++++++++++++++++++++++++++++++++++

iptables -t filter -A INPUT -p tcp --dport 9000:10000 -m comment --comment "GLOBUS_TCP_PORT_RANGE" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 2119 -m comment --comment "GRAM" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 2811 -m comment --comment "GridFTP" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 9619:9620 -m comment --comment "HTCondor-CE" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 8080 -m comment --comment "Storage Resource Manager" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 8443 -m comment --comment "GUMS + Storage Resource Manager" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 7512 -m comment --comment "MyProxy" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 15001:16000 -m comment --comment "VOMS" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 3128 -m comment --comment "Squid" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 3401 -m comment --comment "Squid monitor" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 3306 -m comment --comment "MySQL" -j ACCEPT


iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -t filter -A INPUT -p icmp -m comment --comment "Allow pings" -j ACCEPT
iptables -t filter -A INPUT -p udp -m udp --dport 137:138 -m comment --comment "Silent drop of WIN SCAN" -j DROP


#Table nat
iptables -t nat -A PREROUTING  -j ACCEPT
iptables -t nat -A POSTROUTING -j ACCEPT
iptables -t nat -A OUTPUT      -j ACCEPT

#Table raw
iptables -t raw -A PREROUTING  -j ACCEPT
iptables -t raw -A OUTPUT      -j ACCEPT

