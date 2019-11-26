class rm_nodes {

#package {"mc":
#        ensure => latest,
#}

file {"wn_remove_peaceful.sh":
    ensure =>present,
    path => "/nfs/condor/nodes_for_edit.lst",

}

#########
exec { "rm_nodes":
command =>  "/bin/bash -c '/nfs/condor/wn_remove_peaceful.sh'",

}




} # class switch_off_peaceful


