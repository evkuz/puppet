class wn_osg_el7::set_fqdn_no_dns{
   file { "/root/set_fqdn_no_dns.sh":
    ensure => file,
    source => 'puppet:///modules/wn_osg_el7/set_fqdn_no_dns.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',

    notify => Exec["set_fqdn_no_dns.sh"],
    }

    exec { "set_fqdn_no_dns.sh":
#      command => "./set_fqdn.sh",  # ТАК НЕ РАБОТАЕТ !!!
#      path    => "/root/",         # ТАК НЕ РАБОТАЕТ !!!
    command =>  "/bin/bash -c '/root/set_fqdn_no_dns.sh'",
    refreshonly => true,

    }

}
