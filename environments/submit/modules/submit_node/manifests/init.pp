#Submit node stuff

class submit_node {

contain submit_node::put_ssh_key
contain submit_node::cvmfs

############## add ntpd service check
service {"ntpd":
  ensure => running,
  enable => 'true',
  hasstatus =>'false',
  status    => 'service ntpd status | /bin/grep -q "is running"',
  stop  => 'service ntpd stop && /bin/rm -f /var/run/ntpd.pid'
}

##########################################################

service {'rsyslog':
   ensure  => 'running',
#   enable  => true,
   restart => 'service rsyslog restart',
   hasrestart => true,

}
################################################################

#service {'libvirtd':
#   ensure  => 'stopped',
#   enable  => false,
#   stop    => '/sbin/ip link set virbr0-nic down',
#}



#####################################################################################
#  Задаем /etc/rsyslog.conf
   file { "/etc/rsyslog.conf":
    ensure => file,
    source => 'puppet:///modules/submit_node/rsyslog.conf',
    mode => "0644",
    owner => 'root',
    group => 'root',
    notify => Service['rsyslog'],

    }

#  Задаем /root/init_lvm.sh
   file { "/root/init_lvm.sh":
    ensure => file,
    source => 'puppet:///modules/submit_node/init_lvm.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',

    }

################################# Проверяем наличие папок /mnt/condor/spool, /mnt/condor/execute, необходимых для condor
# Т.к. это submit-узлы, то не нужна папка /mnt/condor/execute
 file {['/mnt/condor', '/mnt/condor/spool']:
  ensure => directory,
  mode   => "0755",
  owner  => "condor",
  group  => "condor",
  }

# exclude osg-oasis as it's submit node
package {['redhat-lsb-core','krb5-workstation', 'mosh', 'singularity', 'cpuid']:
ensure => latest
#, 'osg-wn-client-glexec'
}


# contain submit_node::authconfig_ldap

}
