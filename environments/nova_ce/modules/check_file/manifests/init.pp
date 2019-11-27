class check_file {

package {'lsof':
ensure => latest,
}
# cut runinterval=300


#file_line {"remove_runinterval":
#ensure => absent,
#path   => '/etc/puppetlabs/puppet/puppet.conf',
##line   => '',
#match  => '^runinterval=300',
#match_for_absence => true,
#}

}
