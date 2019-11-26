#!/bin/bash

########    iptables for cloud-osg-ce.jinr.ru  ##############


echo "Loading iptables rules"

NET_JINR="159.93.0.0/16"

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


#Table filter


#iptables -t filter -A INPUT -s 159.93.0.0/16 -p tcp -m tcp --dport 22 -m comment --comment "Allow SSH" -j ACCEPT
iptables -t filter -A INPUT -s $NET_JINR -j ACCEPT

#+++++++++++++++++++++++ GRID special rules ++++++++++++++++++++++++++++++++++++++++++++++++++++

iptables -t filter -A INPUT -p tcp --dport 9000:10000 -m comment --comment "GLOBUS_TCP_PORT_RANGE" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 2119 -m comment --comment "GRAM" -j ACCEPT
#iptables -t filter -A INPUT -p tcp -m tcp --dport 2811 -m comment --comment "GridFTP" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 9619:9620 -m comment --comment "HTCondor-CE" -j ACCEPT
#iptables -t filter -A INPUT -p tcp -m tcp --dport 8080 -m comment --comment "Storage Resource Manager" -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 8443 -m comment --comment "Gratia Service" -j ACCEPT
#iptables -t filter -A INPUT -p tcp -m tcp --dport 7512 -m comment --comment "MyProxy" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 15001:16000 -m comment --comment "VOMS" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 3128 -m comment --comment "Squid" -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 3401 -m comment --comment "Squid monitor" -j ACCEPT
#iptables -t filter -A INPUT -p tcp --dport 3306 -m comment --comment "MySQL" -j ACCEPT


#+++++++++++++++++++++++++++ NFS ports ++++++++++++++++++++++++++++++++++++++++++++++++
# grep nfs /etc/services
# grep portmap /etc/services

iptables -t filter -A INPUT -p tcp --dport nfs -m comment --comment "Network File System" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport nfs -m comment --comment "Network File System" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport netconfsoaphttp -m comment --comment "NETCONF for SOAP over HTTPS" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport netconfsoaphttp -m comment --comment "NETCONF for SOAP over HTTPS" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport netconfsoapbeep -m comment --comment "NETCONF for SOAP over BEEP" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport netconfsoapbeep -m comment --comment "NETCONF for SOAP over BEEP" -j ACCEPT

iptables -t filter -A INPUT -p udp --dport nfsd-keepalive -m comment --comment "Client status info" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport picknfs -m comment --comment "picknfs" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport picknfs -m comment --comment "picknfs" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 3d-nfsd  -m comment --comment "3d-nfsd" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 3d-nfsd  -m comment --comment "3d-nfsd" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport mediacntrlnfsd  -m comment --comment "Media Central NFSD" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport mediacntrlnfsd  -m comment --comment "Media Central NFSD" -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport nfsrdma  -m comment --comment "Network File System (NFS) over RDMA" -j ACCEPT
iptables -t filter -A INPUT -p udp --dport nfsrdma  -m comment --comment "Network File System (NFS) over RDMA" -j ACCEPT



#netconfsoaphttp 832/tcp                 # NETCONF for SOAP over HTTPS
#netconfsoaphttp 832/udp                 # NETCONF for SOAP over HTTPS
#netconfsoapbeep 833/tcp                 # NETCONF for SOAP over BEEP
#netconfsoapbeep 833/udp                 # NETCONF for SOAP over BEEP
#nfsd-keepalive  1110/udp                # Client status info
#picknfs         1598/tcp                # picknfs
#picknfs         1598/udp                # picknfs
#shiva_confsrvr  1651/tcp                # shiva_confsrvr
#shiva_confsrvr  1651/udp                # shiva_confsrvr
#3d-nfsd         2323/tcp                # 3d-nfsd
#3d-nfsd         2323/udp                # 3d-nfsd
#mediacntrlnfsd  2363/tcp                # Media Central NFSD
#mediacntrlnfsd  2363/udp                # Media Central NFSD
#winfs           5009/tcp                # Microsoft Windows Filesystem
#winfs           5009/udp                # Microsoft Windows Filesystem
#nfsrdma         20049/tcp               # Network File System (NFS) over RDMA
#nfsrdma         20049/udp               # Network File System (NFS) over RDMA
#nfsrdma         20049/sctp              # Network File System (NFS) over RDMA





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

