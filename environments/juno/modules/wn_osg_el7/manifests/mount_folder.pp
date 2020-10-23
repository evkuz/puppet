# Монтируем папку /nova
class wn_osg_el7::mount_folder {

######### Создаем папку /nova ########

# file {'/nova':
#  ensure => directory,
#  mode   => "0755",
#  }

######### Монтируем /nova ########

#mount {'/nova':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована
#ensure => mounted, #defined (also called present), unmounted, absent, mounted
#atboot => true,
#device => '10.93.221.50:/nova',
#fstype => 'nfs',
#options => 'rw,vers=4.1',
#remounts => true,
#}

#######################  Создаем папку /nfs
# /nfs    -fstype=nfs,defaults condor.jinr.ru:/nfs
# /mnt/local_repo -fstype=nfs,defaults condor.jinr.ru:/mnt/vdc

# file {'/nfs':
#  ensure => directory,
#  mode   => "0777",
#  }
####################### Монтируем папку /nfs
mount {'/nfs':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована
ensure => mounted, #defined (also called present), unmounted, absent, mounted
atboot => true,
device => 'condor.jinr.ru:/nfs',
fstype => 'nfs',
options => 'defaults',
remounts => true,
}



# Получаем Duplicate declaration, поэтому комментируем

# file {['/mnt/condor', '/mnt/cvmfs']:
#  ensure => directory,
#  mode   => "0755",
#  }

#file { '/var/lib/condor':
#  ensure => link,
#  target => '/mnt/condor/',
#  owner => 'condor',
#  group => 'condor',
#  force => true,

#}





}
