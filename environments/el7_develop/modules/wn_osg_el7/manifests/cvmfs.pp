class wn_osg_el7::cvmfs {
#
        package {"cvmfs":
# Вместо cvmfs-config-default используется :
#        cvmfs-config-osg.noarch              2.4-1.osg35.el7            @osg
        ensure => present,

        }

############################## add cvmfs settings
   file { "/etc/cvmfs/default.local":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/cvmfs_default.local', # develop сработает ли ?
    mode => "0644",
    owner => 'root',
    group => 'root',
    
#    require => Package["cvmfs-config-default"],
    notify => Exec["cvmfs_apply"],
    }

    exec { "cvmfs_apply":
#      command     => "/bin/bash -c cvmfs_config probe && ls /cvmfs/nova.opensciencegrid.org",
#      command => "cvmfs_config probe",
      command => "ls /cvmfs/nova.opensciencegrid.org",
      path    => "/bin/",
    }

}
####################### configure fstab
# By default ресурс file_line doesn't support multiple lines, но при этом в качестве line можно задать массив строк.
# для удобочитаемости кода каждую строку запишем в виде отдельной переменной, и добавим эти переменные в массив.
# Если в файле на агенте уже такие строки есть, но в другом порядке, то файл останется без изменений.
# Т.е. проверяется наличие такой строки в файле, а уж в каком порядке - не важно.

$line_1 = "/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    defaults        0       0"
$line_2 = "/dev/mapper/wn-condor   /mnt/condor     ext4    defaults        0       0"
$line_3 = "10.93.221.50:/nova	   /nova	   nfs	   rw,vers=4.1	   0	   0"
file_line {"nfs_folders":
ensure => present,
path   => '/etc/fstab',
line   => [$line_1, $line_2, $line_3],

#match  => '^#\sinclude\s"/usr/share/nano/sh.nanorc"',
# match will look for a line beginning with "# include /usr/share/nano/sh.nanorc" and replace it with the value in "line"
#/dev/mapper/wn-cvmfs    /mnt/cvmfs      ext4    defaults        0       0
#/dev/mapper/wn-condor   /mnt/condor     ext4    defaults        0       0


}
