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

notify {" The  /etc/ek-hosts-develop is present! ":}
