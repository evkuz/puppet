#include autofs
#include packages
#include check_file
#include network
#include gridmap_check 
#include fwall

include wn_osg
#include check_template
#include yum_update


#Задаем параметры сетевого интерфейса eth0 для файла /etc/sysconfig/network-scripts/ifcfg-eth0
#После модуль network сам делает  service newtork restart
# Модуль был нужен, когда надо было переписать gateway на всех агентах
# На сегодня, 19.12.2018, можно пока отключить.

#network::interface {'eth0':
# ipaddress => $ipaddress,
# netmask   => $netmask,
# gateway   => '10.93.220.1',

#}

#class {"fwall":

#script_path => "/etc/sysconfig",
#script_name => "iptables-wn.sh",
#}

#class {'gridmap_check':
#etalon => '/home/check_content.txt',
#nfs_located => '/root/check_content.txt',
#}


###########  Это для тестов 
#check_file::destination_file {'/home/anaconda-ks.cfg':
#source_file => "/root/anaconda-ks.cfg",
#}
###########  END OF Это для тестов

