class submit_node::put_ssh_key {

    file { "/root/.ssh/authorized_keys":
    ensure => file,
    source => "puppet:///modules/submit_node/authorized_keys",
    mode => "0600",
    owner => 'root',
    group => 'root',

#    notify  => Class[$notify_class],
    }


}
