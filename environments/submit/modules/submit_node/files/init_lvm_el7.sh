#!/bin/bash
#
############ ATTENTION !!!! ###############
# cvmfs and condor  packages must be installed BEFORE applying this script
#
##########################################
#
# mount | grep "^/dev"

me=`basename "$0"`
############################### parameters 
LVMD="/dev/vdb"
DNAME="submit"
VNAME_1="cvmfs"
VNAME_2="home"

LV_1_SZ="20G"
LV_2_SZ="150G"


SETUPLOG="/var/log/node_lvm_setup.log"

touch $SETUPLOG
cp /dev/null $SETUPLOG


echo "$(date +"%d-%m-%Y %T") Start running $me script" |& tee -a $SETUPLOG

# first check the list of LVMs
LVM_LINES="$(lvs -a -o +devices | wc -l )" # | grep $DEV $SWAP_LINES -lt 3 | wc -l)"

if [[ $LVM_LINES -ne "0" ]]; then
   echo "$(date +"%d-%m-%Y %T") YES ! LVM exists on $LVMD, so skip other LVM-related steps" |& tee -a $SETUPLOG
else
# if not exist we create it 
   echo "$(date +"%d-%m-%Y %T")  There is no LVM on $LVMD, so let's create it !" |& tee -a $SETUPLOG

    pvcreate $LVMD
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [pvcreate $LVMD]" |& tee -a $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" |& tee -a $SETUPLOG
	fi
###################
#   DNAME="submit"
   vgcreate $DNAME $LVMD
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully createed volume group $DNAME on $LVMD" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not create volume group $DNAME on $LVMD]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not create volume group $DNAME on $LVMD" >> $SETUPLOG
	fi
fi # of else
################## Now create logical volumes
#   VNAME_1="cvmfs"
VPATH_1="/var/lib/cvmfs"
lvs | grep $VNAME_1
     if [ $? -eq 0 ]; then # Значит раздел уже есть
        echo "$(date +"%d-%m-%Y %T") The volume $VNAME_1 is already exists, so do nothing and go next step" >> $SETUPLOG
        else # Значит раздела нет, тогда создем
	   lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME
        	if [ $? -eq 0 ]; then
	          echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >> $SETUPLOG
       		else
	          echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >&2
          	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >> $SETUPLOG
                fi
     fi

#   lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME
#	if [ $? -eq 0 ]
#	then
#	  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >> $SETUPLOG
#	else
#	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >&2
#	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L$LV_1_SZ $DNAME]" >> $SETUPLOG
#	fi
##################
   sleep 2
#   VNAME_2="home"
   RESULT=0 # TRUE,SO DO WHILE TRUE
#lvs | grep $VNAME_2
#lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME
#   while [ $? -ne 0 ]; do
#    echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
#    lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME
#   done
#   echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
lvs | grep $VNAME_2
     if [ $? -eq 0 ]; then # Значит раздел уже есть

        echo "$(date +"%d-%m-%Y %T") The volume $VNAME_2 is already exists, so do nothing and go next step" >> $SETUPLOG
        else # Значит раздела нет, тогда создем
           lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME
                if [ $? -eq 0 ]; then
                  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
                else
                  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >&2
                  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
                fi
     fi


#	if [ $? -eq 0 ]
#	then
#	  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
#	else
#	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >&2
#	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L$LV_2_SZ $DNAME]" >> $SETUPLOG
#	fi
#################
#fi # of else
############################################## Условие проверили, теперь форматируем фс.
  sleep 3
df -Th | grep "^/dev" | grep $VNAME_1
     if [ $? -eq 0 ]; then # Значит fs уже есть 
       echo "$(date +"%d-%m-%Y %T") The file system on $VNAME_1 is already exists, so do nothing and go next step" >> $SETUPLOG
     else
	  mkfs.ext4 -L $VNAME_1 /dev/$DNAME/$VNAME_1
		if [ $? -eq 0 ]; then
	  	    echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L $VNAME_1 /dev/$DNAME/$VNAME_1]" >> $SETUPLOG
		else
	  	    echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_1 /dev/$DNAME/$VNAME_1]" >&2
	  	    echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_1 /dev/$DNAME/$VNAME_1]" >> $SETUPLOG
	        fi
     fi
#################
df -Th | grep "^/dev" | grep $VNAME_2
     if [ $? -eq 0 ]; then # Значит fs уже есть 
       echo "$(date +"%d-%m-%Y %T") The file system on $VNAME_2 is already exists, so do nothing and go next step" >> $SETUPLOG
     else
	  mkfs.ext4 -L $VNAME_2 /dev/$DNAME/$VNAME_2
	  if [ $? -eq 0 ]; then
	     echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L $VNAME_2 /dev/$DNAME/$VNAME_2]" >> $SETUPLOG
	  else
	     echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_2 /dev/$DNAME/$VNAME_2]" >&2
	     echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_2 /dev/$DNAME/$VNAME_2]" >> $SETUPLOG
	  fi
     fi
#################
   sleep 3
########################################### Теперь монтируем
   VPATH_1="/var/lib/cvmfs"
   mount /dev/$DNAME/$VNAME_1 $VPATH_1
	if [ $? -eq 0 ]
	then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/$DNAME/$VNAME_1 $VPATH_1]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/$DNAME/$VNAME_1 $VPATH_1]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/$DNAME/$VNAME_1 $VPATH_1]" >> $SETUPLOG
	fi
#################
sleep 3
   VPATH_2="/home"
   mount /dev/$DNAME/$VNAME_2 $VPATH_2
	if [ $? -eq 0 ]
	then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/$DNAME/$VNAME_2 $VPATH_2]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/$DNAME/$VNAME_2 $VPATH_2]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/$DNAME/$VNAME_2 $VPATH_2]" >> $SETUPLOG
	fi
#################
#fi # of else

echo "$(date +"%d-%m-%Y %T") Finishing script $me" |& tee -a $SETUPLOG
sleep 5

#cp -rp /home/condor/* /mnt/condor

#{ echo "/dev/mapper/wn-cvmfs    /mnt/cvmfs              ext4    defaults              0 0" >> /etc/fstab ;
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab ;
#chown -R cvmfs:cvmfs /mnt/cvmfs ;
#chown condor:condor /mnt/condor ;
#} >> $SETUPLOG
#ls /cvmfs/nova.opensciencegrid.org
