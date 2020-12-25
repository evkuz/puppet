# Дублируем тут монтирование, которое выполняет autofs

class mount_nfs{
#######################  Создаем папку /nfs
# /nfs    -fstype=nfs,defaults condor.jinr.ru:/nfs
# /mnt/local_repo -fstype=nfs,defaults condor.jinr.ru:/mnt/vdc

 file {'/nfs':
  ensure => directory,
  mode   => "0777",
  }


####################### Монтируем папку /nfs
mount {'/nfs':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована
ensure => mounted, #defined (also called present), unmounted, absent, mounted
atboot => true,
device => 'condor.jinr.ru:/nfs',
fstype => 'nfs',
options => 'rw,vers=4.1',
remounts => true,
}






 file {['/mnt/condor', '/mnt/cvmfs']:
  ensure => directory,
  mode   => "0755",
  }


}
