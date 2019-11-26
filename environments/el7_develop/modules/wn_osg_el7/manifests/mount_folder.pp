class wn_osg_el7::mount_folder {

######### Создаем папку /nova ########

 file {'/nova':
  ensure => directory,
  mode   => "0755",
  }

######### Монтируем /nova ########

mount {'/nova':
# Set to present to add to fstab but not change mount/unmount status.
# Поэтому если она не была смонтирована, то так и останется не смонтирована
ensure => mounted, #defined (also called present), unmounted, absent, mounted
atboot => true,
device => '10.93.221.50:/nova',
fstype => 'nfs',
options => 'rw,vers=4.1',
remounts => true,
}


}
