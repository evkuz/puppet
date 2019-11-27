# This manifest is to update htcondor via it's native repository
# And then restart iptables as service

#- get file-script with iptables rules
#- apply iptables via script
#- save iptables to native format file
#- restart iptables as service

# $::network::params::config_dir_path

#script_path - путь к директории, куда будет сохранен исполняемый скрипт
#script_name - имя файла под которым скрипт будет сохранен


class htcondor_update (
 $current_version = undef,
) {  

# ensure that current version is the latest 

#   service { 'condor':
  
#       ensure => running,
#       enable => true,
#       require => Package['iptables'],	


#   }


   file { "/nfs/condor/condor-etc/RPM-GPG-KEY-HTCondor":
	
    ensure => present,
#    source => 'https://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor',
#    mode => "0644",
#    replace => true,
#    notify => Exec["import_gpg_key"], # посылаем refresh для "import_gpg_key"
    }


    exec { "import_gpg_key": # Import the signing key
      path      => '/bin:/usr/bin:/sbin:/usr/sbin',
#      command     => "/bin/bash -c rpm --import /etc/yum.repos.d/RPM-GPG-KEY-HTCondor",
       command     => "rpm --import /nfs/condor/condor-etc/RPM-GPG-KEY-HTCondor",

#      path        => "${script_path}",
      require     => File["/nfs/condor/condor-etc/RPM-GPG-KEY-HTCondor"],
      refreshonly => true,
#      notify => Exec["Get_the_repository_file"], # посылаем refresh для "Get_the_repository_file"
#      notify => Package["condor"]
      

    }

# get the repository file
   file { "/etc/yum.repos.d/htcondor-stable-rhel6.repo":

    ensure => present,
    source => 'https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel6.repo',
    mode => "0644",
    replace => true,
    # Возможно лишнее
    subscribe =>Exec["import_gpg_key"],
    notify => Package["condor"], # посылаем refresh для "condor"
    }



   package { 'condor':
     ensure => latest,
     require => File["/etc/yum.repos.d/htcondor-stable-rhel6.repo"],
   }


#    exec {"Get_the_repository_file": # Get the repository file
#      notify => Service['iptables'], # Все так, но сервис берет за основу конфиг /etc/sysconfig/iptables ... а мы-то следим за содержимым скрипта iptables-wn-osg.sh
#      command   => "iptables-save > /etc/sysconfig/iptables",
#      path      => "/sbin",
#      refreshonly => true,

#    }



}
