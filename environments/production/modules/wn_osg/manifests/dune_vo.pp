class wn_osg::dune_vo {

   user { 'dune': ensure => present, }

   group { 'dune': ensure => present, }

# Было актуально именно для замены. Потом, когда уже на всех узлах как надо, скопируем эту строку прямо в ..files/cvmfs_default.local
# $cvm_repo = "CVMFS_REPOSITORIES=nova.opensciencegrid.org,nova.osgstorage.org,mu2e.opensciencegrid.org,\
#fermilab.opensciencegrid.org,dune.opensciencegrid.org,dune.osgstorage.org,larsoft.opensciencegrid.org"

#   file_line {"CVMFS_repos":
#      ensure => present,
#      path   => '/etc/cvmfs/default.local',
#      line   => $cvm_repo,
#"CVMFS_REPOSITORIES=nova.opensciencegrid.org,nova.osgstorage.org,mu2e.opensciencegrid.org,fermilab.opensciencegrid.org,dune.opensciencegrid.org,dune.osgstorage.org,larsoft.opensciencegrid.org"
#      match  => '^CVMFS_REPOSITORIES=nova.opensciencegrid.org, mu2e.opensciencegrid.org',
# match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in line
#}


}
