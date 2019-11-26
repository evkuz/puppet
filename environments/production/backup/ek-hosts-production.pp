file { '/etc/ek-hosts-production':
  ensure => present,
  content => "
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.93.221.8 puppet-osg.jinr.ru
$ipaddress $hostname localhost

",
  mode => "0644",
  owner => 'root',
  group => 'root'
}

