# 
# https://serverfault.com/questions/255562/puppet-running-shell-command-when-file-or-package-is-updated
# 
# 24.10.2017 Версия рабочая, однако смущает предупреждение: The `audit` metaparameter is deprecated and will be ignored in a future release.
# Пытался использовать функцию getparam(), однако она выдает значения только тех параметров, которые задаются при объявлении ресурса.
# Например выдает значение 'owner', если оно задано при объявлении ресурса file
# Т.е. непонятно, как получить доступ к readonly-параметрам
#

class gridmap_check  (
$etalon,
$nfs_located,
) {

file {"source_file":
  ensure => file,
  checksum => mtime,
  path => $etalon,
#  audit => mtime,
#  notify => Exec['MY_COPY']

  }


file {"${nfs_located}":
  ensure => file,
  checksum => mtime,
  }

file {"/home/test_gridmap.txt":
  ensure => present,
  content => "
To be or not to be ??????????
$ipaddress $hostname localhost

",
  mode => "0644",
  owner => 'gopher',
  group => 'gopher'
}



# Так возвращает пустое значение
#$source_mtime = getparam(File[$etalon], "mtime")
#$dest_mtime   = getparam(File[$nfs_located], "mtime")

#$source_mtime = getparam(File['/home/check_content.txt'], 'mtime')
#$dest_mtime   = getparam([nfs_located], "mtime")

#$source_mtime = "xlkcjgv"

#$source_mtime = File['/home/check_content.txt']['mtime']

# ТАк работает, параметр owner есть при объявлении ресурса
#$source_mtime = File["/home/test_gridmap.txt"]["owner"]

#А так уже не работает, mtime - это readonly-параметр
$source_mtime = getparam(File['/home/test_gridmap.txt'], 'mtime')

unless $source_mtime == $dest_mtime {
File[$etalon] -> Exec['MY_COPY']

 }#unless




 exec { 'MY_COPY':
#/bin/\cp -p ${etalon} ${nfs_located}
       command => "cp -p ${etalon} ${nfs_located}",
       path    => '/bin/',
       refreshonly => true, #If refreshonly is set to true, the exec will only run when it receives an event. This is the most reliable way to use refresh with execs.
       provider => 'shell', # VERY IMPORTANT OPTION !!!! It allows execute '\cp' command, removing alias of the command
#       cwd     => '/etc',
#       unless  => "$source_mtime == $dest_mtime",
    }#'MY_COPY'

exec {'MY_ECHO':
 command => "echo source_file mtime is $source_mtime > /home/echo_output",
 path => '/bin/',
 provider => 'shell',


}#'MY_ECHO'

File['source_file'] -> Exec['MY_ECHO']

#unless $source_mtime == $dest_mtime {

#    exec { 'cp -p $source_mtime $dest_mtime':
#       command => '\cp -p $source_mtime ${dest_mtime}',
#       path    => "/bin",
#       cwd     => '/etc',
#    }
#  }




 
}
