file { "/home/wntester/check_puppet.txt":
owner => "wntester",
group => "wntester",
mode => "644",
}

node default {

$source_gridmap = 'cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile'
$dest_gridmap   = '/home/'


include rsync

rsync::get {'/home/':
  source  => "rsync://${source_gridmap}",
  options => '-p',
  path    => $dest_gridmap,
#  require => File['/foo'],
}


}

#include rsync
#include gridmap
