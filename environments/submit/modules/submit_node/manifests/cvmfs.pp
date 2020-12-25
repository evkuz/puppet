class submit_node::cvmfs {

# file {'/mnt/cvmfs':
#  ensure => directory,
#  mode   => "0755",
#  owner => 'cvmfs',
#  group => 'cvmfs',
  
#  }


package {"cvmfs":
  ensure => present,
#  before => File['/mnt/cvmfs'],
  }


# 08.12.2020 Убираем, т.к. решено монтировать напрямую в /var/lib/cvmfs
#file { '/var/lib/cvmfs':
#  ensure => link,
#  target => '/mnt/cvmfs/',
#  owner => 'cvmfs',
#  group => 'cvmfs',
#  force => true,
#  require => Package["cvmfs"],
#}

#file {'/mnt/cvmfs':
#  ensure => directory,
#  mode   => "0755",
#  owner => 'cvmfs',
#  group => 'cvmfs',
#  require => Package["cvmfs"],
  
#  }



############################## add cvmfs settings
   file { "/etc/cvmfs/default.local":
    ensure => file,
    source => 'puppet:///modules/submit_node/cvmfs_default.local', # develop сработает ли ?
    mode => "0644",
    owner => 'cvmfs',
    group => 'cvmfs',
    
#    require => Package["cvmfs-config-default"],
    notify => Exec["cvmfs_apply"],
    }

    exec { "cvmfs_apply":
      command     => "/bin/bash -c 'cvmfs_config probe'",
#&& ls /cvmfs/nova.opensciencegrid.org'",
#      command => "cvmfs_config probe",
#      command => "ls /cvmfs/nova.opensciencegrid.org",
      path    => "/bin/",
    }


################# 
   file { "/etc/cvmfs/domain.d/jinr.ru.conf":
    ensure => file,
    source => 'puppet:///modules/submit_node/cvmfs/domain.d/jinr.ru.conf', # develop сработает ли ?
    mode => "0644",
    owner => 'cvmfs',
    group => 'cvmfs',

#    require => Package["cvmfs-config-default"],
    notify => Exec["cvmfs_apply"],
    }

#################   directory
   file { "/etc/cvmfs/keys/jinr.ru":
    ensure =>  directory,
    mode => "0644",
    owner => 'cvmfs',
    group => 'cvmfs',

    notify => Exec["cvmfs_apply"],
    }
################

   file { "/etc/cvmfs/keys/jinr.ru/jinr.ru.pub":
    ensure => file,
    source => 'puppet:///modules/submit_node/cvmfs/keys/jinr.ru.pub', # develop сработает ли ?
    mode => "0644",
    owner => 'cvmfs',
    group => 'cvmfs',

    require => File["/etc/cvmfs/keys/jinr.ru"],
    notify => Exec["cvmfs_apply"],
    }






#}
####################### configure fstab
## Надо с этим разобраться.
# By default ресурс file_line doesn't support multiple lines, но при этом в качестве line можно задать массив строк.
# для удобочитаемости кода каждую строку запишем в виде отдельной переменной, и добавим эти переменные в массив.
# Если в файле на агенте уже такие строки есть, но в другом порядке, то файл останется без изменений.
# Т.е. проверяется наличие такой строки в файле, а уж в каком порядке - не важно.

$line_1 = "/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    defaults        0       0"
$line_2 = "/dev/mapper/wn-condor   /mnt/condor     ext4    defaults        0       0"
#$line_3 = "10.93.221.50:/nova	   /nova	   nfs	   rw,vers=4.1	   0	   0"

#file_line {"cvmfs_automount":
#ensure => present,
#path   => '/etc/fstab',
#line   => [$line_1, $line_2],
#}


#match  => '^#\sinclude\s"/usr/share/nano/sh.nanorc"',
# match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in "line"
#/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    defaults        0       0
#/dev/mapper/wn-condor   /mnt/condor     ext4    defaults        0       0


#file {'absent_cvmfs':
#  path => '/var/lib/cvmfs',
#  ensure => absent,
#}



#file { '/var/lib/cvmfs':
#  ensure => link,
#  target => '/mnt/cvmfs/',
#  owner => 'cvmfs',
#}





} #class wn_osg_el7::cvmfs


