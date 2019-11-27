define check_file::destination_file(

$source_file = undef,
#$dest_file   = undef,
) {

file {$title:
source =>$source_file,
mode =>'0644',

}

}
