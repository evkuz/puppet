# that works !
#class main::mymain {


class pupp_master {

package {['lsof', 'nmap-ncat']:
   ensure => latest
}

notify { 'class pupp_master for module pupp_master passed':
        withpath => false,
}

contain pupp_master::main

} # class pupp_master
