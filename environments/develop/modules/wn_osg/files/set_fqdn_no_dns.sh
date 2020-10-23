#!/bin/bash

# Этот файл необходим для формирования правильного Hostname для работы с puppet мастером.
# Поэтому этот файл размещается на агенте, без выполнения этого скрипта узел-агент не сможет подключиться к мастер серверу.

#06.11.2018
#НА некотороых хостах не 2, а 3 сетевых интерфейса, добавляется docker:
# Поэтому делаем выборку по eth0


#08.08.2018 02

#hostname формируем на основе ip-адреса и прописываем в 
#/etc/hosts
#/etc/sysconfig/network
#/etc/sysctl.conf

# 17.12.2019
# Формируем в другом виде xxx-xxx-xxx-xxx

# Не всегда интерфейс называется eth0, поэтому заменяем название интерфейса на '.*' 26.11.2019
# 04.12.2019 Однако у всех узлов один и тот же broadcast "brd 10.93.223.255"
#IP=$(echo `/sbin/ip a` | sed -n -e 's/^.*inet \(.*\)\(scope global .*\).*/\1/p' | cut -d ' ' -f1 | cut -d '/' -f1)
IP=$(echo `/sbin/ip a` | sed -n -e 's/^.*inet \(.*\)\(brd 10.220.31.255\).*/\1/p' | cut -d ' ' -f1 | cut -d '/' -f1)
#echo "IP=$IP"
SUBN=$(echo $IP | cut -d'.' -f3)
#echo "SUBN=$SUBN"
NUM=$(echo $IP | cut -d'.' -f4)
# | cut -d'/' -f1)
#echo "NUM=$NUM"
# | cut -d'/' -f1)
#echo "NUM=$NUM"
FQDN="10-220-"${SUBN}"-"${NUM}".jinr.ru"
SHORT="10-220-"${SUBN}"-"${NUM}

#Вот тут задаем hostname и не надо ничего перезагружать.
/bin/hostname ${FQDN}

echo "My name is ${FQDN}"

################### MASTER COMMANDS ###########
# puppet cert clean $FQDN

WHICH_RELEASE=$(cat /etc/redhat-release  | cut -d ' ' -f4 | cut -d '.' -f1)

#echo "The release number is $WHICH_RELEASE"
if [ $WHICH_RELEASE -eq 7 ]
then
#  echo "$(date +"%d-%m-%Y %T") It's Centos 7"
   hostnamectl set-hostname  ${FQDN}
elif [ $WHICH_RELEASE -eq 6 ]
then
#   echo "$(date +"%d-%m-%Y %T") It's Centos 6"
    sed -i "s/^HOSTNAME=.*/HOSTNAME=${SHORT}/" /etc/sysconfig/network
    sed -i "s/^kernel.hostname.*/kernel.hostname = ${FQDN}/" /etc/sysctl.conf
else
   echo "$(date +"%d-%m-%Y %T") Unknown version !!!"
fi



# set hostname of the agent
#sed -i "s/^HOSTNAME=.*/HOSTNAME=${SHORT}/" /etc/sysconfig/network

#sed -i "s/^kernel.hostname.*/kernel.hostname = ${FQDN}/" /etc/sysctl.conf




cp /dev/null /etc/hosts

printf "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n" >> /etc/hosts
printf "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n" >> /etc/hosts
printf "10.93.221.8 puppet-osg.jinr.ru\n" >> /etc/hosts
printf "$IP ${FQDN} localhost\n" >> /etc/hosts

# 18.02.2020 После смены имени надо перезапустить логи
service rsyslog restart

#/etc/init.d/network restart
#service network restart

# And push puppet agent to get certificate an retrieve catalogue

#FILE="/etc/puppetlabs/puppet/ssl/certs/${FQDN}.pem"

#if [ ! -f $FILE ]
#then
#    echo "Сертификат для ${FQDN} не существует, создаем новый"
#puppet agent -t --waitforcert 5

#else 
#puppet agent -t

#fi


