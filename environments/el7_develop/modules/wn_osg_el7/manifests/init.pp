class wn_osg_el7 {

	package {['mc', 'tree']:
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

}
#############################################3

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
#service {"ntpd":
#  ensure => running,
#  enable => 'true',
#  hasstatus =>'true',
#}
############################## check content of /etc/rc.d/rc.local
   file { "/etc/rc.d/rc.local":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/rc.local',
    mode => "0755",
    owner => 'root',
    group => 'root',
}
############################## add set_fqdn.sh script
contain wn_osg_el7::set_fqdn
#   file { "/root/set_fqdn.sh":
#    ensure => file,
#    source => 'puppet:///modules/wn_osg_el7/set_fqdn.sh',
#    mode => "0755",
#    owner => 'root',
#    group => 'root',

#    notify => Exec["set_fqdn.sh"],
#    }

#    exec { "set_fqdn.sh":
##      command => "./set_fqdn.sh",  # ТАК НЕ РАБОТАЕТ !!!
##      path    => "/root/",         # ТАК НЕ РАБОТАЕТ !!!
#    command =>  "/bin/bash -c '/root/set_fqdn.sh'",
#    refreshonly => true,

#    }
##############################



contain wn_osg_el7::autofs
contain wn_osg_el7::cvmfs
contain wn_osg_el7::mount_folder
#contain wn_osg_el7::set_fqdn
  service { 'ntpdate':
    ensure => running,
    enable => true,
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
