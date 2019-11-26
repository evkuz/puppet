# 07.12.2017
# packages.pp
# class with absent packages to be installed 

#libgomp required for OSG tasks to perform on the WN

class packages {
  package { 'libgomp':
    ensure => latest
  }

# notify {'The libgomp package is uptodate! ':}

$msg = "Everything in it's right place."
notify { $msg: }


#  package { 'nfs-utils-lib':
#    ensure => latest
#  }
}
