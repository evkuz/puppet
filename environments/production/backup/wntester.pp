file { "/home/wntester/check_puppet.txt":
ensure => present,
owner => "wntester",
group => "wntester",
mode => "644",
}
