# 26.10.2017 Проверено. Работает.
# content changed '{md5}d26b87312c0eda178b30ad2da0f622d7' to '{md5}c7697e3d9ee4566deb326c0077ea3ece'
# Applied catalog in 0.15 seconds 
define check_file::destination_file(

$source_file = undef,
#$dest_file   = undef,
) {

file {$title:
source =>$source_file,
mode =>'0644',

}


# Rebuild the database, but only when the file changes
#exec { 'newgrid-mapfile':
#  subscribe   => File[$source_file],
#  refreshonly => true,
#}





}
