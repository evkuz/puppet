# Настраиваем authconfig  для ldap, kerberos

class submit_node::authconfig_ldap {

  package { [ 'nss-pam-ldapd', 'authconfig', 'pam_krb5', 'oddjob-mkhomedir']:
    ensure => latest,
#    notify => File['/etc/nslcd.conf', '/etc/nsswitch.conf', '/etc/pam_ldap.conf'], #service restart
  }

    file { "/etc/nslcd.conf":
    ensure => file,
    source => "puppet:///modules/submit_node/nslcd.conf",
    mode => "0600",
    owner => 'root',
    group => 'root',

    notify  => Service['nslcd'], #service restart
    }


    file { "/etc/nsswitch.conf":
    ensure => file,
    source => "puppet:///modules/submit_node/nsswitch.conf",
    mode => "0644",
    owner => 'root',
    group => 'root',

#    notify  => Class[$notify_class], #service restart
    }

    file { "/etc/pam_ldap.conf":
    ensure => file,
    source => "puppet:///modules/submit_node/pam_ldap.conf",
    mode => "0644",
    owner => 'root',
    group => 'root',

#    notify  => Class[$notify_class], #service restart
    }

   
   service {'nslcd':
   name => "nslcd", #"/etc/rc.d/init.d/nslcd",
   ensure => running,
   enable => true,
   hasrestart => true,
   restart => "",
   }
  
   exec {"authconfig":
   command => 'authconfig --enablekrb5 --krb5realm JINR.RU --krb5kdc kerberos.jinr.ru:88,kerberos-1.jinr.ru:88,kerberos-2.jinr.ru:88 --krb5adminserver kerberos.jinr.ru:749 --enablemkhomedir --update',
   path    => '/usr/sbin/',
   
   }

 exec {"authconfig_02":
   command => 'authconfig --enableldap --ldapserver="ldap://auth-1.jinr.ru/,ldap://auth-2.jinr.ru/,ldap://auth-3.jinr.ru/" --ldapbasedn="dc=jinr,dc=ru" --update',
   path    => '/usr/sbin/',
}

# --enablekrb5 --krb5realm JINR.RU --krb5kdc kerberos.jinr.ru:88,kerberos-1.jinr.ru:88,kerberos-2.jinr.ru:88 --krb5adminserver kerberos.jinr.ru:749 --enablemkhomedir --update
}
