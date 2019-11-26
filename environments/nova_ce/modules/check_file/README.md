Модуль check_file.

Модуль синхронизирует файл заданный как destination_file с файлом, заданным как $source_file.
Т.е. файл destination_file всегда такой же как $source_file, а если в destination_file есть отличия от $source_file, 
то puppet переписывает destination_file из файла $source_file.
