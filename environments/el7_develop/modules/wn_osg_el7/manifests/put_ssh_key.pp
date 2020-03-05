class wn_osg_el7::put_ssh_key {

    file { "/root/.ssh/authorized_keys":
    ensure => file,
    source => "puppet:///modules/wn_osg_el7/authorized_keys",
    mode => "0600",
    owner => 'root',
    group => 'root',

#    notify  => Class[$notify_class],
    }


}
