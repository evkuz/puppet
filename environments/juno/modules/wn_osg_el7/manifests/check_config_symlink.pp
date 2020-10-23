class wn_osg_el7::check_config_symlink {
#Скрипт check_file_type.sh проверяет наличие символьной ссылки "/etc/condor/condor_config", запускает condor, если не запущено.

   file { "/root/check_file_type.sh":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/check_file_type.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',

    notify => Exec["check_file_type.sh"],
    }

    exec { "check_file_type.sh":
    command =>  "/bin/bash -c '/root/check_file_type.sh'",
    refreshonly => true,

    }
# Добавить удаление файла /root/check_file_type.sh после выполнения скрипта

}

