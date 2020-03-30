# remove worknode from pool
class wn_osg::drain_wn_on {
#$hostname = 'undefined'


   exec { "rm_nodes":
# Сцуко, точка, перед скриптом очень важна !!!
# command =>  "/bin/bash -c 'condor_drain -graceful $host'",
command =>  "/bin/bash -c 'service condor stop'",
}


}
