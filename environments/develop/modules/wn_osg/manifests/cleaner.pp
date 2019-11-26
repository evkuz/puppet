# В этом классе будем удалять все лишнее с узлов
# пакеты, файлы, и т.д.

define wn_osg::cleaner ($file_names) {

# ['/root/check_local_echo.sh', '/root/ek-routing.sh', 'init.sh', 'install.log', 'install.log.syslog', \
#         '/root/jobs_log', '/root/one-context_4.10.0.rpm','/root/repo_config', '/root/repo_config_mu2e', '/root/today_jobs_log' ]

 file { $file_names:
  ensure => absent,
  }






#    file { "/etc/yum.repos.d/$name":
#    ensure => file,
#    source => "puppet:///modules/wn_osg/$name",
#    mode => "0644",
#    owner => 'root',
#    group => 'root',

#    notify  => Class[$notify_class],
#    }
}

