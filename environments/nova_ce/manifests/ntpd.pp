class ntpd {

 package {"ntp":
 ensure => latest,

}

 package {"ntpdate":
 ensure => latest,

}

service {"ntpd":
  ensure => running,
  enable => 'true',
  hasstatus =>'true',
}



} # class ntpd
