#Общий класс для найстройки WN-OSG

# - Ставим : nfs, autofs 
# - настраиваем поддержку cvmfs
# - следим за актуальностью пакета libgomp, 
# - Задаем содержимое файла /etc/resolv.conf
# - Запускаем сервис ntpd, если не работает
# - Задаем hostname на основе ip/subnet - выполняем скрипт set_fqdn, если его содержимое поменялось на  master-е
# - Задаем содержимое /etc/rc.d/rc.local
# - Создаем/следим, что есть - папку /mnt/local_repo , монтируем туда nfs-папку из condor.jinr.ru
# - Задаем конфиг репозитория osg-el6.repo, в котором указан путь в nfs-папку из condor.jinr.ru, и если он меняется выполняем скрипт update_osg.sh
 
# - следим за актуальностью пакета yum-plugin-fastestmirror
# - Задаем временные рамки для выполнения ресурса 'osg_update' - ежедневно, в заданные часы, 1 раз.
# - Задаем конфиг репозитория sl6x.repo, который обновляется с локального зеркала linux4u.jinr.ru
# - Задаем конфиг репозитория epel.repo, который обновляется с локального зеркала linux4u.jinr.ru - http://linux4u.jinr.ru/pub/SL.epel/6/
# - Выполняем по schedule ежедневное обновление пакетов через скрипт update_osg.sh, затем удаление скрипта update_osg.sh на агенте.
# - Задаем посдветку синтаксиса для bash в nano
# - Добавляем файл /usr/share/nano/bash.nanorc чтобы работала подсветка синтаксиса nano  для 
#   файлов *.bash, а не только для *.sh    

# - Создаем дополнительную nfs-папку /nova 22.01.2019

# - 1-Разовая операция : Добавить переименование 'htcondor-stable-rhel6.repo.repo' -> 'htcondor-stable-rhel6.repo' в /etc/yum.repos.d/
#   Данная задача решилась использованием класса  wn_osg::cleaner{}, который удаляет заданный файл, 
#   в нашем случае - "неправильный" '/etc/yum.repos.d/htcondor-stable-rhel6.repo.repo',
#   далее срабатывает класс wn_osg::htcondor_repo{}, следящий за файлом репозитория (ресурс yumrepo{} вот тут задаем теперь имя без расширения).
#   
# - Проверяем наличие symlink /etc/condor/condor_config  ->  /nfs/condor/condor-etc/condor_config.global  //exec {"check_presence"://
#
# - Задаем /root/.ssh/authorized_keys   
#
# - Задаем /etc/condor/config.d/local.conf
# - Проверяем, что сервис libvirtd НЕ запущен
# - Убираем строку running interval = 300
# - Ставим пакет krb5-workstation
# - Добавляем пакет osg-wn-client-glexec к списку обязательных.
# - Добаляем настройки для проекта DUNE в отдельном классе DUNE_VO
# - Ставим пакет osg-oasis. Нужно для CVMFS
# - Ставим пакет singularity, есть на это запрос пользователей.
# - Проверяем ОТСУТСТВИЕ пакета telnet
# - Ставим пакет CPUID. Навеяно работой в fasm

#include wn_osg::htcondor_repo
#include wn_osg::authconfig_ldap

#include yum_update
#include check_template

class wn_osg {

#  include autofs
#  include network

######################### 27.11.2019
#contain wn_osg::yum_update
######################### 25.11.2019
contain  wn_osg::put_ssh_key

################################# 20.02.2020
contain wn_osg::dune_vo

######################### 30.05.2019 ###########################
#contain wn_osg::authconfig_ldap

########################################################## 16.12.2019

##############################################


file_line {"unset_run_interval_1":
ensure => absent,
path   => '/etc/puppetlabs/puppet/puppet.conf',
match  => '^runinterval=300', 
match_for_absence => true,
multiple => true
}

file_line {"unset_run_interval_2":
ensure => absent,
path   => '/etc/puppetlabs/puppet/puppet.conf',
match  => '^runinterval = 180',
match_for_absence => true,
multiple => true
}

file_line {"set_run_interval_3":
ensure => absent,
path  => '/etc/puppetlabs/puppet/puppet.conf',
line  => 'runinterval=900',
}

file_line {"set_run_interval_4":
ensure => absent,
path  => '/etc/puppetlabs/puppet/puppet.conf',
line  => 'runinterval=600',
}

#ensure => absent,
file_line {"set_run_interval":
#ensure => absent,
path  => '/etc/puppetlabs/puppet/puppet.conf',
line  => 'runinterval=1800',
}

##########################################################

service {'rsyslog':
   ensure  => 'running',
#   enable  => true,
   restart => 'service rsyslog restart',
   hasrestart => true,

}
################################################################

service {'libvirtd':
   ensure  => 'stopped',
   enable  => false,
   stop    => '/sbin/ip link set virbr0-nic down',
# && /usr/sbin/brctl delbr virbr0',
}



#####################################################################################
#  Задаем /etc/condor/config.d/local.conf
   file { "/etc/rsyslog.conf":
    ensure => file,
    source => 'puppet:///modules/wn_osg/rsyslog.conf',
    mode => "0644",
    owner => 'root',
    group => 'root',
    notify => Service['rsyslog'],

    }


######################################################



# Снимаем коммент строчки в файле /etc/nanorc чтобы включилась подсветка синтаксиса nano для sh-файлов
# Хорошая альтернатива sed

file_line {"tune_nanorc":
ensure => present,
path   => '/etc/nanorc',
line   => 'include "/usr/share/nano/sh.nanorc"',
match  => '^#\sinclude\s"/usr/share/nano/sh.nanorc"', 
# match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in line
}
################### 13.12.2019 ##################################################################
#  Задаем /etc/condor/config.d/local.conf
   file { "/etc/condor/config.d/local.conf":
    ensure => file,
    source => 'puppet:///modules/wn_osg/local.conf',
    mode => "0644",
    owner => 'root',
    group => 'root',

    }



################### 08.05.2019 ##################################################################
# Для обновления версии condor необходимо подключить репозиторий osg-upcoming
# Либо отредактировать соответствующий файл *.repo - не подходит, т.к. в файле несколько одинаковых строк
# ...
# 03.10.2019 Также это помогло при ОТКЛЮЧЕНИИ репозитория osg-upcoming, т.к. он перестал работать с OSG 3.4, и доступен только для версии OSG 3.5
# Да, используем массив/список репозиториев, так тоже можно было :)
wn_osg::repo_file {["osg-el6-upcoming.repo", "osg-el6.repo"]: notify_class =>'yum_update', }
#file_line {"osg_upcoming_enabled":
#ensure => present,
#path   => '/etc/yum.repos.d/osg-el6-upcoming.repo',
#line   => 'enabled=1', # Такая строка должна быть
#match  => '^enabled=0.*', # match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in line
#multiple => true,
#replace_all_matches_not_matching_line => false,
#}



#yumrepo { 'osg-el6-upcoming.repo':

#ensure  => present,
#enabled => yes,
#priority => 35,

#}



################### 22.01.2019 ###########
# Создаем папку /nova
# Добавляем строку в /etc/fstab для монтирования новой nfs-папки /nova
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab

 file {'/nova':
  ensure => directory,
  mode   => "0755",
  }

file_line {"tune_fstab":
#ensure => present,
path   => '/etc/fstab',
line   => '10.93.221.50:/nova    /nova                    nfs     rw,vers=4.1       0 0',
#notify => Exec["mount_nova_apply"],
}

#    exec {"mount_nova_apply":
#      command => "./set_fqdn.sh",  # ТАК НЕ РАБОТАЕТ !!!
#      path    => "/bin/",         # ТАК НЕ РАБОТАЕТ !!!
#    command =>  "/bin/mount /nova",
#    refreshonly => true,
#    }


######### Монтируем /nova ########

mount {'/nova':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована
ensure => mounted, #defined (also called present), unmounted, absent, mounted
atboot => true,
device => '10.93.221.50:/nova',
fstype => 'nfs',
options => 'rw,vers=4.1',
remounts => true,
}

########################################### END OF 22.01.2019 ##############################################

############# подсветка *.bash  файлов
   file { "/usr/share/nano/bash.nanorc":
    ensure => file,
    source => 'puppet:///modules/wn_osg/bash.nanorc', 
    mode => "0644",
    owner => 'root',
    group => 'root',

    }

############# 06.07.2020 подсветка *.sh  файлов
   file { "/usr/share/nano/sh.nanorc":
    ensure => file,
    source => 'puppet:///modules/wn_osg/sh.nanorc', 
    mode => "0644",
    owner => 'root',
    group => 'root',

    }



#####################################################################################
#  package { [ 'nfs-utils', 'nfs-utils-lib', 'autofs', 'libgomp', 'yum-plugin-fastestmirror']:
#    ensure => latest
#  }

package {['lsof', 'redhat-lsb-core','krb5-workstation', 'osg-oasis', 'singularity', 'cpuid']:
ensure => latest
#, 'osg-wn-client-glexec'
}

package {'telnet':
ensure => absent
}

################################# Создаем папку /nfs если такой нет
 file {'/nfs':
  ensure => directory,
  mode   => "0777",
  }

#################################
 file {'/mnt/local_repo':
  ensure => directory,
  mode   => "0755",
  }

################################
file { '/etc/auto.master':
  ensure => present,
  content => "
/cvmfs /etc/auto.cvmfs
/- /etc/auto.nfs
+auto.master
",
  mode => "0644",
  owner => 'root',
  group => 'root',
  notify => Service['autofs'],
}
###############################
file { '/etc/auto.nfs':
  ensure => present,
  content => "
/nfs    -fstype=nfs,defaults condor.jinr.ru:/nfs
/mnt/local_repo -fstype=nfs,defaults condor.jinr.ru:/mnt/vdb
+auto.nfs
",
  mode => "0644",
  owner => 'root',
  group => 'root',
 # require => package['autofs']
  notify => Service['autofs'],
}
###############################
# The actual command used to restart the service depends on the platform and can be configured:
# If you set hasrestart to true, Puppet will use the init script’s restart command.
# You can provide an explicit command for restarting with the restart attribute.
# If you do neither, the service’s stop and start commands will be used.
  service { 'autofs':
    ensure => running,
    enable => true,
    restart =>  "/bin/bash -c 'service autofs restart'" ,
 #   notify => Service["condor_restart"],
  }
############################## add cvmfs settings
   file { "/etc/cvmfs/default.local":
    ensure => file,
    source => 'puppet:///modules/wn_osg/cvmfs_default.local', # develop сработает ли ?
    mode => "0644",
    owner => 'root',
    group => 'root',

    notify => Exec["cvmfs_apply"],
    }

    exec { "cvmfs_apply":
#      command     => "/bin/bash -c cvmfs_config probe && ls /cvmfs/nova.opensciencegrid.org",
#      command => "cvmfs_config probe",
      command => "ls /cvmfs/nova.opensciencegrid.org",
      path    => "/bin/",
    }

#  service { "condor_restart":
#    require => Service['autofs'],
#    name   => "condor",
#    ensure => running,
#    enable => true,
#    restart =>  "/bin/bash -c 'service condor restart'" ,
#  }

   
###########################  add resolv.conf content
file {"/etc/resolv.conf":
  ensure => present,
  content => "
nameserver 159.93.17.7
nameserver 159.93.14.7
",
   mode => "0644",
   owner => 'root',
   group => 'root',
}

############## add ntpd service check
service {"ntpd":
  ensure => running,
  enable => 'true',
  hasstatus =>'false',
  status    => 'service ntpd status | /bin/grep -q "is running"',
  stop  => 'service ntpd stop && /bin/rm -f /var/run/ntpd.pid'
}
############################## check content of /etc/rc.d/rc.local
   file { "/etc/rc.d/rc.local":
    ensure => file,
    source => 'puppet:///modules/wn_osg/rc.local',
    mode => "0755",
    owner => 'root',
    group => 'root',
}
############################## add set_fqdn.sh script
# Заменяем весь вышестоящий блок 1 строчкой

contain wn_osg::set_fqdn_no_dns

############################## 
# Вот тут важен порядок следования.
# сначала обновляем "epel.repo", где "exclude=condor*", а уж потом сам htcondor, начиная с создания репозитория

############################## add osg-el6.repo, sl6x.repo, epel.repo with path to local  linux4u.jinr.ru
 
# wn_osg::repo_file {"osg-el6.repo": notify_class =>'yum_update', } # см. выше строка 74, там включен уже этот репозиторий.
 wn_osg::repo_file {"sl6x.repo"   : notify_class =>'yum_update', }
 wn_osg::repo_file {"epel.repo"   : notify_class =>'yum_update', }

# contain yum_update

############################## htcondor repository
# comment on 03.10.2019 : replace htcondor_repo with htcondor_update
# uncomment on 04.10.2019 - get back htcondor_repo
contain wn_osg::htcondor_repo

package {'condor':
    ensure  => 'installed',
    require => Class['wn_osg::htcondor_repo'],
#     require => Class['htcondor_update'],
#    notify  => Class['yum_update'],
}


####### 10.01.2019 А теперь добавим обновление репозитория htcondor-stable-rhel6

# wn_osg::repo_file {"epel.repo"   : notify_class =>'yum_update', }

# contain yum_update

# ensure that package 'mc' is installed when 'yum_update' applied
# this was used to check that @sl6x repo has been updated and used
# package {'mc':
# ensure => latest,
# subscribe =>  Class['yum_update'],
#}


###################################################### 14.10.2019 Check symlink for /etc/condor/condor_config -> /nfs/condor/condor-etc/condor_config.global

#  command =>  "/bin/bash -c '/root/set_fqdn.sh'",
# ln -s /path/to/file /path/to/symlink
# 1. Check that condor_config is not a symlink but a regular file

# см. backup

#file { '/etc/inetd.conf':
#  ensure => link,
#  target => '/etc/inet/inetd.conf',
#}

contain wn_osg::check_config_symlink



#/etc/puppetlabs/code/environments/develop/modules/wn_osg
}#  class wn_osg
###############################################################################

