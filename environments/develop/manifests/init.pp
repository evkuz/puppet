########################## Сцуко, очень важно тут прописать !!!
include wn_osg
include yum_update
#include service_restart

#include iface_down
include network


#Задаем параметры сетевого интерфейса eth0 для файла /etc/sysconfig/network-scripts/ifcfg-eth0
#После модуль network сам делает  service newtork restart
# Модуль был нужен, когда надо было переписать gateway на всех агентах
# На сегодня, 19.12.2018, можно пока отключить.


#contain iface_down

###############################################################
network::interface {'eth0':
 ipaddress => $ipaddress,
 netmask   => $netmask,
 gateway   => '10.93.220.1',

}

network::interface {'virbr0':

ensure => absent,
}

network::interface {'virbr0-nic':

ensure => absent,
}


class {"fwall":

script_path => "/etc/sysconfig",
script_name => "iptables-wn.sh",
}

###########  Это для тестов 
#check_file::destination_file {'/home/anaconda-ks.cfg':
#source_file => "/root/anaconda-ks.cfg",
#}
###########  END OF Это для тестов

