# 
# https://serverfault.com/questions/255562/puppet-running-shell-command-when-file-or-package-is-updated
# 
# 24.10..2017 Версия рабочая, однако смущает предупреждение: The `audit` metaparameter is deprecated and will be ignored in a future release.
# 
#Warning: /File[source_file]/audit: The `audit` metaparameter is deprecated and will be ignored in a future release.
#   (at /etc/puppetlabs/code/environments/develop/modules/gridmap_check/manifests/init.pp:12)
# Info: Applying configuration version '1508849719'
# Notice: /Stage[main]/Fwall/Exec[iptables_apply]/returns: executed successfully
# Notice: /Stage[main]/Fwall/Exec[iptables_save]/returns: executed successfully
# Notice: /Stage[main]/Gridmap_check/File[source_file]/mtime: audit change: previously recorded value 2017-10-24 13:42:54 +0300 has been changed to 2017-10-24 15:55:07 +0300
# Info: /Stage[main]/Gridmap_check/File[source_file]: Scheduling refresh of Exec[MY_COPY]
# Notice: /Stage[main]/Gridmap_check/Exec[MY_COPY]: Triggered 'refresh' from 1 events
# Notice: Applied catalog in 2.05 seconds

#

class gridmap_check  (
$etalon,
$nfs_located,
) {

file {"source_file":
  ensure => file,
  path => $etalon,
  audit => mtime,
  notify => Exec['MY_COPY']

  }


file {"dest_file":
  ensure => file,
  path => $nfs_located,
  }


 exec { 'MY_COPY':
       command => "\cp -p ${etalon} ${nfs_located}",
       path    => '/bin/',
       refreshonly => true, #If refreshonly is set to true, the exec will only run when it receives an event. This is the most reliable way to use refresh with execs.
       provider => 'shell', # VERY IMPORTANT OPTION !!!! It allows execute '\cp' command, removing alias of the command
#       unless  => "$source_mtime == $dest_mtime",
    }#'MY_COPY'


 
}
