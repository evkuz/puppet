#!/bin/bash
START_GROUP=50004
FINISH_GROUP=50050

START_NAME=fermilab
# groupadd -g 50000 fermilab001

i=$START_GROUP
 while [ $i -lt $FINISH_GROUP ]
do

if [ $i -le 50008 ]
then
    NUMBER="00"
fi

if [[ $i -ge 50009 && $i -le 50099 ]]
then
    NUMBER="0"
fi

DIFFER=$[$i-50000+1]
groupadd -g $i fermilab$NUMBER$DIFFER

i=$[$i+1]
done



