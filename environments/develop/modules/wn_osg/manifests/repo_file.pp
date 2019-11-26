# define *.repo files to source them in the master

define wn_osg::repo_file ($notify_class) {

    file { "/etc/yum.repos.d/$name":
    ensure => file,
    source => "puppet:///modules/wn_osg/$name",
    mode => "0644",
    owner => 'root',
    group => 'root',

    notify  => Class[$notify_class],
    }
}
