class gridmap{
$source_gridmap = 'cloud-osg-ce.jinr.ru'
$dest_gridmap   = '/home'

#include rsync

rsync::get { '/home/gridmap':
  source  => "rsync://$source_gridmap/etc/grid-security/grid-mapfile",
#  options => '-p',
  path    => $dest_gridmap,
#  require => File['/home/gridmap'],
}

}
