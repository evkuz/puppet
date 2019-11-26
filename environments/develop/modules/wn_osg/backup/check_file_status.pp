# 14.10.2019 Сохраню, т.к. долго провозился.
# А для фиксации опыта будет полезно.
exec {"is_the_condor_config_regular":
      command => '/bin/false',
      onlyif => '/usr/bin/test -L /etc/condor/condor_config',

}

# rename '/etc/condor/condor_config' to /etc/condor/condor_config_last if it is regular file
exec {"rename_the_condor_config_regular":
    command => '/bin/mv /etc/condor/condor_config  /etc/condor/condor_config_last',
    require => Exec["is_the_condor_config_regular"],
    notify => Exec["create_symlink_for_condor_config"],
}

exec {"is_the_condor_config_a_symlink":
      command => '/bin/true',
      onlyif => '/usr/bin/test -L /etc/condor/condor_config',

}


exec {"create_symlink_for_condor_config":
    command => "/bin/ln -s /nfs/condor/condor-etc/condor_config.global /etc/condor/condor_config",
    require => Exec["is_the_condor_config_a_symlink"],
    notify => Service["condor_restart"],
}

