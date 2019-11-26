#$script_path = "/etc/sysconfig/",
#$script_name = "iptables-ek.sh",

# Пока Только объявляем ресурс с параметрами

define fwall::fw_script (

$script_path = undef,
$script_name = $name,
) {

   file { "${script_path}/${script_name}":
    ensure => file,
    source => 'puppet:///modules/fwall/iptables-wn-osg.sh',
    mode => "0755",
    notify => Exec["iptables_apply"],
    }


    exec { "iptables_apply":
      command     => "/bin/bash -c ${script_path}/${script_name}",
#      path        => "${script_path}",
#      require     => File["${script_path}/${script_name}"],
#      refreshonly => true,
    }


    exec {"iptables_save":
      command   => "iptables-save > /etc/sysconfig/iptables",
      path      => "/sbin",

    }

   file {"$script_path/iptables":

      ensure => file,
      mode   => "0644",

    }
}

