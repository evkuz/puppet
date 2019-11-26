class wn_osg::check_config_symlink {

   file { "/root/check_file_type.sh":
    ensure => file,
    source => 'puppet:///modules/wn_osg/check_file_type.sh',
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
