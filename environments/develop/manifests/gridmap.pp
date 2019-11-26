
class gridmap {

$osg_gridmap = 'cloud-osg-ce.jinr.ru:/etc/condor-ce/config.d/99-local.conf'

#file {'/home/grid-mapfile':
#  ensure => file,
 # source => 'puppet://cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile',
#  }

exec {"Use gridmap":
#  require => File[$my_file_arg],
  command => "rsync -p $osg_gridmap /home",
}



#file {'/home/grid-mapfile':
#  ensure => file,
#  source => 'puppet://cloud-osg-ce.jinr.ru:/etc/grid-security/grid-mapfile',
#  }

}#gridmap



