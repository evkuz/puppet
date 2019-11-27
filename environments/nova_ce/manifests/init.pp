include check_file
include ntpd
check_file::destination_file {'/nfs/condor/condor-etc/grid-mapfile':
source_file => "/etc/grid-security/grid-mapfile",

}
