file_line {"/etc/rsyslog.conf":
   ensure   => 'present',
   path     => '/etc/rsyslog.conf',
   after    => '# Use default timestamp format',
   line     => '$template EKtemplate,"%$day%-%$month%-%$year% %timegenerated:12:19:date-rfc3339% %HOSTNAME% %syslogseverity-text:0:3:uppercase% %msg%\n$

}

################ replace line  it works !!! ###################
file_line {'replace_line_rsyslog':
#   ensure            => absent,
   path     => '/etc/rsyslog.conf',
   match     => '^\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat',
   replace  => true,
   line     => '$ActionFileDefaultTemplate EKtemplate',
   notify   => Service['rsyslog'],
}



