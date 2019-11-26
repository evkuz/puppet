class wn_osg::remove_nodes {

package {"mc":
        ensure => latest,
}

#file {"remove_peaceful":
#    ensure =>present,
#    path => "/nfs/condor/nodes_for_edit.lst",

#}

#########
exec { "rm_nodes":
# Сцуко, точка, перед скриптом очень важна !!!
 command =>  "/bin/bash -c '/nfs/condor/./wn_remove_peaceful.sh'", 

}




} # class switch_off_peaceful

