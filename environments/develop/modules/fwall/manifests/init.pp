# This manifest is to apply iptables via script and save newly installed iptables to default file
# And then restart iptables as service

#- get file-script with iptables rules
#- apply iptables via script
#- save iptables to native format file
#- restart iptables as service

# $::network::params::config_dir_path

#script_path - путь к директории, куда будет сохранен исполняемый скрипт
#script_name - имя файла под которым скрипт будет сохранен


class fwall (
 $script_path = undef,
 $script_name = undef,
) {  

   package { 'iptables':
     ensure => installed,
   }

   service { 'iptables':
  
       ensure => running,
       enable => true,
       require => Package['iptables'],	


   }


   file { "${script_path}/${script_name}":
	
#   notify => Service['iptables'], # Все так, но сервис берет за основу конфиг /etc/sysconfig/iptables ... а мы-то следим за содержимым скрипта iptables-wn-osg.sh
    ensure => file,
    source => 'puppet:///modules/fwall/iptables-wn-osg.sh',
    mode => "0755",
    notify => Exec["iptables_apply"], # посылаем refresh для "iptables_apply"
    }


    exec { "iptables_apply": # Выполняем скрипт, переписывающий все правила
      command     => "/bin/bash -c ${script_path}/${script_name}",

#      path        => "${script_path}",
      require     => File["${script_path}/${script_name}"],
      refreshonly => true,
      notify => Exec["iptables_save"], # посылаем refresh для "iptables_save"

    }


    exec {"iptables_save":
      notify => Service['iptables'], # Все так, но сервис берет за основу конфиг /etc/sysconfig/iptables ... а мы-то следим за содержимым скрипта iptables-wn-osg.sh
      command   => "iptables-save > /etc/sysconfig/iptables",
      path      => "/sbin",
      refreshonly => true,

    }


}
