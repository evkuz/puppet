file { '/etc/ek-hosts-develop':
  ensure => present,
  content => "
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.93.221.8 puppet-osg.jinr.ru

",
  mode => "0644",
  owner => 'root',
  group => 'root'
}


file { '/home/grid-mapfile':
  ensure => link,
  target => '/nfs/condor/condor-etc/grid-mapfile',


}

#$ek_command
exec {'cp -p /etc/hosts /etc/hosts.00':
#       command =>"$ek_command",
	path => ['/bin/', '/usr/bin', '/usr/sbin',],

  }


