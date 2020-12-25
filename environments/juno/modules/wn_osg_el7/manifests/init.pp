# - Проверяем наличие symlink /etc/condor/condor_config  ->  /nfs/condor/condor-etc/condor_config.global  //exec {"check$
# - Проверяе актуальное состояние файла init_lvm_el7.sh

class wn_osg_el7 {

	package {['mc', 'tree', 'nmap-ncat', 'ntp']:
        	  ensure => present,
        }
	
        package {'yum-plugin-priorities':
	ensure => installed,
	provider => yum,
	}

# Делаем символьную ссылку на volatile диск, весь ..execute/ и  ../spool condor-а будет туда смонтирован
file { '/var/lib/condor':
  ensure => link,
  target => '/mnt/condor/',
  owner => 'condor',
  group => 'condor',
  force => true,

}
#############################################3
contain wn_osg_el7::rsyslog

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
    source => 'puppet:///modules/wn_osg_el7/rc.local',
    mode => "0755",
    owner => 'root',
    group => 'root',
}
############################## add set_fqdn.sh script
# But why do it regulary ? 
# ...because sheet happens like changing ip of puppet master
contain wn_osg_el7::set_fqdn_no_dns
##############################



contain wn_osg_el7::autofs
#Было /nova /nfs. Теперь тут (в juno) только /nfs
contain wn_osg_el7::mount_folder
contain wn_osg_el7::cvmfs

contain wn_osg_el7::put_ssh_key

##################################### fstab проверка наличия нужных строк
file_line {"tune_fstab_cvmfs":
ensure => present,
path   => '/etc/fstab', 
line   => '/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    rw,relatime,data=ordered',
}

file_line {"tune_fstab_condor":
ensure => present,
path   => '/etc/fstab', 
line   => '/dev/mapper/wn-condor   /mnt/condor      ext4    rw,relatime,data=ordered',
}


##################################### Подсветка nano
# Это не сработает, если не установлен модуль stdlib, т.к. в нем ресурс file_line
# Либо, если модуль установлен, но не заинклуден в самом начале окружения.
file_line {"tune_nanorc":
ensure => present,
path   => '/etc/nanorc',
line   => 'include "/usr/share/nano/sh.nanorc"',
match  => '^#\sinclude\s"/usr/share/nano/sh.nanorc"',
# match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in line
}
############# подсветка *.bash  файлов
   file { "/usr/share/nano/bash.nanorc":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/bash.nanorc',
    mode => "0644",
    owner => 'root',
    group => 'root',

    }

############# 15.07.2020 подсветка *.sh  файлов
   file { "/usr/share/nano/sh.nanorc":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/sh.nanorc',
    mode => "0644",
    owner => 'root',
    group => 'root',

    }


################################################################
#'osg-oasis',
package {['lsof', 'redhat-lsb-core','krb5-workstation', 'singularity', 'cpuid']:
ensure => latest
#, 'osg-wn-client-glexec'
}

package {'telnet':
ensure => absent
}

#condor stopped
#service {"condor":
#  ensure => stopped,
#  enable => 'false',
#}

###################################################### 14.10.2019 Check symlink for /etc/condor/condor_config -> /nfs/condor/condor-etc/condor_config.global
# 07.09.2020 Не нужно для JUNO
# contain wn_osg_el7::check_config_symlink

###################### check local.conf
############################## check content of /etc/condor/config.d/local.conf
   file { "/etc/condor/config.d/local.conf":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/local.conf',
    mode => "0644",
    owner => 'root',
    group => 'root',
}

   file { "/root/init_lvm_el7.sh":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/init_lvm_el7.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',
}



}# wn_osg_el7

#####################
#file_line {"tune_nanorc":
#ensure => present,
#path   => '/etc/nanorc',
#line   => 'include "/usr/share/nano/sh.nanorc"',
#match  => '^#\sinclude\s"/usr/share/nano/sh.nanorc"', # match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it wit$
#}
################## EPEL7 REPO
# https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#package {"epel-7":
#ensure => installed,
#provider => yum,
#source => "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
#}

#package {"epel-7":
#provider => rpm,
#source => "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
#install_options => '-Uivh',
#ensure => present,
#}


################## OSG 3.5 EL7
# yum install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm
#package {"https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm":
#ensure => latest,
#provider => rpm,
#}

##################### OSG packages
#package {'yum-plugin-priorities':
#ensure => installed,
#provider => yum,
#}

#################### cvmfs cvmfs-config-default
#package {["cvmfs", "cvmfs-config-default"]:
#ensure => latest,
#}

#   file { "/etc/cvmfs/default.local":
#    ensure => file,
#    source => 'puppet:///modules/wn_osg/cvmfs_default.local', # develop сработает ли ?
#    mode => "0644",
#    owner => 'root',
#    group => 'root',

#    notify => Exec["cvmfs_apply"],
#    }

#    exec { "cvmfs_apply":
#      command => "ls /cvmfs/nova.opensciencegrid.org",
#      path    => "/bin/",
#    }

#file { '/var/lib/cvmfs':
#  ensure => link,
#  target => '/mnt/cvmfs/',
#}

#file { '/var/lib/condor':
#  ensure => link,
#  target => '/mnt/condor/',
#}

####################
# Создаем папку /nova
# Добавляем строку в /etc/fstab для монтирования новой nfs-папки /nova
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab

# file {'/nova':
#  ensure => directory,
#  mode   => "0755",
#  }

#file_line {"tune_fstab":
#ensure => present,
#path   => '/etc/fstab',
#line   => '10.93.221.50:/nova    /nova                    nfs     rw,vers=4.1       0 0',
#notify => Exec["mount_nova_apply"],
#}



#}
