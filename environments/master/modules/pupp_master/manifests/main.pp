class pupp_master::main {

package {'tree':
   ensure => latest
}

notify { 'class main for module pupp_master passed':
        withpath => false,
}


}
