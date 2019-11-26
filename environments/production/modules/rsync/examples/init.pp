include rsync
$source_gridmap = 'cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile'
$dest_gridmap   = '/home/'

rsync::get { '/home/':
  source  => "rsync://${source_gridmap}",
  options => '-p',
#  path    => $dest_gridmap,
#  require => File['/foo'],
}

