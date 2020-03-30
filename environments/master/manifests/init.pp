include yum_update
# that works !
# there is main module but no 'main' class which should be at init.pp
include pupp_master
#include main::mymain

#class main {

#package {['lsof', 'nmap-ncat']:
#   ensure => latest
#}

#notify { 'class master passed':
#        withpath => false,
#}

# cut runinterval=300
#file_line {"remove_runinterval":
#ensure => absent,
#path   => '/etc/puppetlabs/puppet/puppet.conf',
#line   => '',
#match  => '^runinterval=300',
#match_for_absence => true,
#}

#}# class master
