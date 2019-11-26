node default {
  include rsync

$source_gridmap = 'cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile'
$dest_gridmap   = '/home'
$rsyncDestHost = 'cloud-osg-ce.jinr.ru'

rsync::get {'/home':
  source  => "${source_gridmap}",
  options => '-p',
  path    => $dest_gridmap,
}


rsync::put {"${rsyncDestHost}:/nfs/condor/condor-etc/":
  source  => "/home/grid-mapfile",
  options => '-p',
  path    => "$rsyncDestHost:/nfs/condor/condor-etc/"
#  require => File['/home/grid-mapfile'],
}

}
