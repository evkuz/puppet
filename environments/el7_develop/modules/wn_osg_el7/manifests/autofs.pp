class wn_osg_el7::autofs {
#
        package {["autofs", "lvm2"]:
        ensure => present,

        }
################################# Создаем папку /nfs если такой нет
 file {'/nfs':
  ensure => directory,
  mode   => "0777",
  }
################################# Создаем папку /mnt/local/repo для хранения локальной копии репозитория OSG
 file {'/mnt/local_repo':
  ensure => directory,
  mode   => "0755",
  }
################################# Проверяем наличие папок /mnt/condor/spool , /mnt/condor/execute, необходимых для condor 
# Владельцы этих папок прописываются в скрипте /root/init_lvm.sh, поэтому используем тут как массив.
# Закомментировано chown -R cvmfs:cvmfs /mnt/cvmfs
 file {['/mnt/condor', '/mnt/condor/execute', '/mnt/condor/spool']:
  ensure => directory,
  mode   => "0755",
  owner  => "condor",
  group  => "condor",
  }

################################ Задаем конфиг autofs
file { '/etc/auto.master':
  ensure => present,
  content => "
/cvmfs /etc/auto.cvmfs
/- /etc/auto.nfs
+auto.master
",
  mode => "0644",
  owner => 'root',
  group => 'root',
  notify => Service['autofs'],
}
###############################
file { '/etc/auto.nfs':
  ensure => present,
  content => "
/nfs    -fstype=nfs,defaults condor.jinr.ru:/nfs
/mnt/local_repo -fstype=nfs,defaults condor.jinr.ru:/mnt/vdb
/nova  -fstype=nfs,rw,vers=4.1 10.93.221.50:/nova
+auto.nfs
",
  mode => "0644",
  owner => 'root',
  group => 'root',
 # require => package['autofs']
  notify => Service['autofs'],
}

###############################
# The actual command used to restart the service depends on the platform and can be configured:
# If you set hasrestart to true, Puppet will use the init script’s restart command.
# You can provide an explicit command for restarting with the restart attribute.
# If you do neither, the service’s stop and start commands will be used.
  service { 'autofs':
    ensure => running,
    enable => true,
    restart =>  "/bin/bash -c 'service autofs restart'" ,
#    notify => Service["condor_restart"],
  }


}

