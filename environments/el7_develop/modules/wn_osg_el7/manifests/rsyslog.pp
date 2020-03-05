class wn_osg_el7::rsyslog {

    file { "/etc/rsyslog.conf":
    ensure => file,
    source => "puppet:///modules/wn_osg_el7/rsyslog.conf",
    mode  => "0644",
    owner => 'root',
    group => 'root',

    notify  => Service['rsyslog'],
    }

   service { "rsyslog":

#    require => Service['autofs'],
    name   => "rsyslog",
    ensure => running,
    enable => true,
    #restart =>  "/bin/bash -c 'service rsyslog restart'" ,
    hasrestart => true, #If you set hasrestart to true, Puppet will use the init script’s restart command.
    
}




}
