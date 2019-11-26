
class gridmap {
file {'/home/grid-mapfile':
  ensure => file,
  source => 'puppet://cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile',
  }

}#gridmap



