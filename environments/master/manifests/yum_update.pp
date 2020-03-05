class yum_update {

#  package { 'osg-wn-client-glexec':
#        ensure => absent,
#  }


schedule { 'osg_update':
  range  => '7 - 8',
  period => daily,
  repeat => 1,

}

# При такой записи - без schedule - файл появляется, если был удален, а удаление файла не происходит, т.к.
# schedule уже отработал

   file { "/root/update_osg.sh":

    schedule => 'osg_update',
    ensure => file,
    source => 'puppet:///modules/master/update_osg.sh',
    mode => "0755",
    owner => 'root',
    group => 'root',

    notify => Exec["update_osg"],
    }



exec {"update_osg":
   
     schedule => 'osg_update',

     command => "/bin/bash -c '/root/update_osg.sh'", # && yum -q -y update
#Вместо скрипта можно просто запускать команду, удалять скрипт потом не надо. Но наличие файла скрипта сообщает, что обновления не прошли.
#command => "yum clean all; yum -q -y update --exclude cvs",
     timeout => 3600,
#     onlyif => "/bin/bash -c '/usr/bin/test `/bin/date +%d` -eq 15 && test `/bin/date +%H` -eq 16 && test `/bin/date +%M` -eq 18 '",  date '+%u' -eq 7
     # Обновляемся только по четверграм (4-й день недели) в 10 утра.
#     onlyif => "/bin/bash -c '/usr/bin/test `/bin/date +%u` -eq 4 && test `/bin/date +%H` -eq 10", 

# Убираю, ибо обновляться надо всегда, но по schedule
# Помним что, если файл скрипта 'update_osg.sh' обновился вне schedule, то следующее обновление
# произойдет только по schedule, т.к. не случится refresh
#     refreshonly => true,
     provider => "shell",
     notify => Exec["remove_update_osg"],
     }

exec {"remove_update_osg":

     command => "/bin/bash -c 'rm -f /root/update_osg.sh'",
     refreshonly => true,
     provider => "shell",

   }

############################################## 22.10.2018 #####################
# Добавляю отдельный {schedule + exec} для удаления update_osg.sh

#schedule { 'rm_osg_update':
#  range  => '7 - 10',
#  period => daily,
#  repeat => 1,

#}


#exec {"rm_update_osg":

#     schedule => 'rm_osg_update',
#     command => "/bin/bash -c 'rm -f /root/update_osg.sh'", 
#     provider => "shell",

#   }
#################################################


notify { 'update-passed':
        withpath => false,
 }

}#class yum_update
#//////////////////////////////////////////////////////

