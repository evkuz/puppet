# Это скрипт запуска. Должен быть в examples/
#script_path  - путь к директории, куда будет сохранен исполняемый скрипт
#script_name  - имя файла под которым скрипт будет сохранен


fwall_defined::fw_script {'iptables-wn.sh':
script_path => "/etc/sysconfig",
#script_name => "iptables",

}
