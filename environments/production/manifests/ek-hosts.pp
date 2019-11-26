file { '/etc/ek-hosts':
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

#include rsync
#include gridmap

#$source_gridmap = 'cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile'
#$dest_gridmap   = '/home/'

#rsync::get { '/home/':
#  source  => "rsync://${source_gridmap}",
#  options => '-p',
#  path    => $dest_gridmap,
#  require => File['/foo'],
#}

