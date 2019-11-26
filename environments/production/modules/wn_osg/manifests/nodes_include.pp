class wn_osg::nodes_include {


file {"list_of_nodes":

    ensure =>present,
    path => "/nfs/condor/nodes_back.lst",
#nodes_for_edit.lst",

}

exec { "include_nodes":
command =>  "/bin/bash -c '/nfs/condor/./wn_startd_peaceful.sh'",

}


}# class return_to_pool

