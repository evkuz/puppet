#script_path - путь к директории, куда будет сохранен исполняемый скрипт
#script_name - имя файла под которым скрипт будет сохранен.

class {"fwall":

script_path => "/etc/sysconfig",
script_name => "iptables-wn.sh",
}
