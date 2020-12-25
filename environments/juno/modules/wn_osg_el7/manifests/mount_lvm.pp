# Дублируем тут монтирование, которое выполняет autofs

class mount_lvm{

############################# Монтируем /dev/mapper/wn-cvmfs, /dev/mapper/wn-condor  
#/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    rw,relatime,data=ordered
#/dev/mapper/wn-condor   /mnt/condor     ext4    rw,relatime,data=ordered

#mount {'/mnt/cvmfs':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована

#ensure => mounted, #defined (also called present), unmounted, absent, mounted
#atboot => true,
#device => '/dev/mapper/wn-cvmfs',
#fstype => 'ext4',
#options => 'rw,relatime,data=ordered',
#remounts => true,



#}

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
