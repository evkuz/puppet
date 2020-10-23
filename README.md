A configuration management system defines what you want a system to look like; 
what you want in config files, what services you want running/stopped, what packages you want installed, 
what users you want, etc, based on whatever conditions you define. 
If a system doesn't match what the config management system says it should look like it changes it to match. 
Reporting of changes is optional but highly recommended. Puppet code should be in version control, git in particular. 
You update that, push it to your masters, or if masterless have your agents pull it before they run. 
Static config files or config file templates would typically be part of that.


Репозиторий для конфигурации puppet + foreman

23.10.2020
- Добавлено окружение juno для одноименного эксперимента
- Добавлено окружение common - пустое, когда puppet не нужен, или мешает.
- Добавлен скрипт make_new_env.sh - создает структуру директорий для нового окружения.
- Обновлен скрипт git_config.sh - Т.к. уже много окружений, а структура примерно одинаковая, то в цикле перебирает все окружения и добавляет в commit нужные папки/файлы
- Множество обновлений в рабочих окружениях

30.03.2020
Save to github

Отработаны следующие возможности: 
- Текстовый файл существует и имеет заданное содрежимое. Задействован ресурс file, content => "..." 
- Директория существует. Ресурс file {ensure => directory} 
- Символьная ссылка существует. Ресурс file {ensure => link, target => ...}
- Сервис существует и запущен. Ресурс service {}.Проверено на пакете autofs. Также проверено, что при изменении сервисного конфига, агент, при скачивании нового конфига, перезапускает у себя сервис с новыми настройками. 
  Также проверено на сервисе iptables. Теперь каждый wn имеет одинаковый для всех файл с правилами. Если отличается, то он переписывается и сервис перезапускается.
  файл для wn iptables хранится НА СЕРВЕРЕ puppet. source => 'puppet:///modules/fwall/iptables-wn-osg.sh'

- Выполнение команды bash. Ресурс exec {'command name'}. Проверено на командах rsync, cp. 
- Использование готового стороннего модуля. Модуль network https://forge.puppet.com/example42/network#usage 
  Модуль создан под разные версии linux, поэтому очень много разных параметров и настроек. Пришлось 1 день допиливать. 
  Файл /etc/puppetlabs/code/environments/develop/modules/network/templates/interface/RedHat.erb
  Файл /etc/puppetlabs/code/environments/develop/modules/network/manifests/interface.pp
  После допиливания на всех узлах WN был изменен default gw при помощи этого модуля. Модуль сам выполняет service network restart.

- Работа с разным environment. Теперь (когда стоит foreman) НЕ достаточно просто изменить имя environment в puppet.conf агента, 
  Нужно через веб-гуй foreman поменять environment у конкретного узла.  После этого конфигурация будет стягиваться уже из другого environment.
  НА дату коммита 11.05.2017 используется 2 environment : production (рабочий) и develop(тестовый).

- Отслеживание изменения файла (время последнего редактирования, содержимое, чексумма)
  Проверено на файле grid-mapfile. Используется метапараметр 'audit', который, однако, deprecated и не будет использоваться в следующих версиях.

- Использование refreshonly для применения ресурса только после выполенения заданного условия
- Использование schedule для применения ресурса в заданное время (аналог cron)
- Использование массивов для удаления/установки нескольких пакетов
- Копирование скрипта из файлового хранилища мастер сервера на агент, выполнение скрипта на агенте, удаление скрипта на агенте.
- Проверка наличия symlink
- Разделение ресурсов по классам и периодическое включение/отключение необходимых ресурсов через класс.
- 27.11.2019 Обновили puppetserver до версии 6.11.1

- 03.12.2019 В прошлых коммитах не работал ресурс "file_line". Установил пакет stdlib c forge.puppet.com конкретно в окружение el7_develop, и после этого ресурс "file_line" заработал как надо. 
             Ставится командой puppet module install puppetlabs-stdlib --version 6.1.0 --environment el7_develop
