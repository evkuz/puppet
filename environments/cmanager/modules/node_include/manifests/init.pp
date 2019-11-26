class node_include {


file {"list_of_nodes":

    ensure =>present,
    path => "/nfs/condor/nodes_back.lst",

}

exec { "include_nodes":
command =>  "/bin/bash -c '/nfs/condor/wn_startd_peaceful.sh'",

}


}# class return_to_pool

