class service_restart {



schedule { 'service_reboot':
  range  => '12 - 14',
  period => daily,
  repeat => 1,

}

notify { 'restart passed':
  schedule => 'service_reboot',     
  message => "Schedule to restart service",
  withpath => false,
  notify  => Service["condor_restart"],
 }




# schedule => 'service_reboot',
  service { "condor_restart":
#    schedule => 'service_reboot',
#    require => Service['autofs'],
    name   => "condor",
    ensure => running,
    enable => true,
    hasrestart => true,
  }



}#class service_restart
#//////////////////////////////////////////////////////

