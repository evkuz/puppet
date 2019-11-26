class wn_osg::set_fqdn {

   file { "/root/set_fqdn.sh":
    ensure => file,
    source => 'puppet:///modules/wn_osg/set_fqdn.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',

    notify => Exec["set_fqdn.sh"],
    }

    exec { "set_fqdn.sh":
#      command => "./set_fqdn.sh",  # ТАК НЕ РАБОТАЕТ !!!
#      path    => "/root/",         # ТАК НЕ РАБОТАЕТ !!!
    command =>  "/bin/bash -c '/root/./set_fqdn.sh'",
    refreshonly => true,

    }

}
