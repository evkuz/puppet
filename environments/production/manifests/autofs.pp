class autofs {
  package { 'nfs-utils':
    ensure => latest
  }

  package { 'nfs-utils-lib':
    ensure => latest
  }

file {'/nfs':
  ensure => directory
  }

  package { 'autofs':
    ensure => latest
  }


file { '/etc/auto.master':
  ensure => present,
  content => "
/cvmfs /etc/auto.cvmfs
/- /etc/auto.nfs
+auto.master
",
  mode => "0644",
  owner => 'root',
  group => 'root',
  notify => Service['autofs'],
}

file { '/etc/auto.nfs':
  ensure => present,
  content => "
/nfs    -fstype=nfs,defaults condor.jinr.ru:/nfs
+auto.nfs
",
  mode => "0644",
  owner => 'root',
  group => 'root',
 # require => package['autofs']
}


  service { 'autofs':
    ensure => running,
    enable => true,
  }



}
