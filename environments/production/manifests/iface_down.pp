class iface_down {

#schedule { 'interface_remove':
#  range  => '12 - 14',
#  period => daily,
#  repeat => 1,

#}



  service { 'libvirtd':
#    schedule => "interface_remove",
    ensure => stopped,
    enable => false,
#    notify => Exec["if_down_virbr0"],
    stop    => '/sbin/ip link set virbr0 down && /usr/sbin/brctl delbr virbr0',
  }

#    exec {"if_down_virbr0":
#    command =>  "/sbin/ip link set virbr0 down && /usr/sbin/brctl delbr virbr0",
#    refreshonly => true,
#    }






} # class iface_down
