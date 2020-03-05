# Убрать счетный узел HTCondor из кластера
class wn_osg::remove_nodes {

package {"mc":
        ensure => latest,
}


#########
exec { "rm_nodes":
# Сцуко, точка, перед скриптом очень важна !!!
 command =>  "/bin/bash -c '/nfs/condor/./wn_remove_peaceful.sh'", 

}




} # class switch_off_peaceful

