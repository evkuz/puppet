#!/bin/bash

SETUPLOG="/var/log/node_setup.log"
DEV="/dev/vdb" # Где искать lvm
VIRT_DEV="wn"  #worknode
LV_1="condor"
LV_2="cvmfs"
LV_1_SZ="150G"
LV_2_SZ="20G"
# first check the list ovf LVMs
LVM_LINES="$(lvs -a -o +devices)" # | grep $DEV $SWAP_LINES -lt 3 | wc -l)"

if [ $? -eq 0 ]
then
   echo "YES ! LVM exists on $DEV, so scip other LVM-related steps" >> $SETUPLOG
else
# if not exist we create it
#echo "SORRY ! LVM IS NOT exists on $DEV"
# create physical volume
  pvcreate $DEV

   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created physical volume on ${DEV}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T")  Could NOT create  physical volume on ${DEV}" >> $SETUPLOG
   fi

# create volume group on devices 
 vgcreate $VIRT_DEV $DEV
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created volume group named ${VIRT_DEV}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T")  Could NOT create volume group named ${VIRT_DEV}" >> $SETUPLOG
   fi


# Now crete logical volimes (LVs)
 lvcreate -n $LV_1 -L$LV_1_SZ $VIRT_DEV
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created logical volume group named ${LV_1}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT create logical volume group named ${LV_1}" >> $SETUPLOG
   fi

 lvcreate -n $LV_2 -L$LV_2_SZ $VIRT_DEV
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created logical volume group named ${LV_2}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT create logical volume group named ${LV_2}" >> $SETUPLOG
   fi
 

# And make fs on these volumes

 mkfs.ext4 -L $LV_1 /dev/$VIRT_DEV/$LV_1
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created file system on ${LV_1}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT create file system on ${LV_1}" >> $SETUPLOG
   fi


 mkfs.ext4 -L $LV_2 /dev/$VIRT_DEV/$LV_2
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully created file system on ${LV_2}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT create file system on ${LV_2}" >> $SETUPLOG
   fi

# mount the volumes to prepared folders
 mount /dev/$VIRT_DEV/$LV_1 /mnt/$LV_1
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully mounted /dev/$VIRT_DEV/$LV_1 to /mnt/${LV_1}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT mount /dev/$VIRT_DEV/$LV_1 to /mnt/${LV_1}" >> $SETUPLOG
   fi

#mount /dev/wn/condor /mnt/condor
 mount /dev/$VIRT_DEV/$LV_2 /mnt/$LV_2
   if [ $? -eq 0 ]
    then
         echo "$(date +"%d-%m-%Y %T") Successfully mounted /dev/$VIRT_DEV/$LV_2 to /mnt/${LV_2}" >> $SETUPLOG
    else
         echo "$(date +"%d-%m-%Y %T") Could NOT mount /dev/$VIRT_DEV/$LV_2 to /mnt/${LV_2}" >> $SETUPLOG
   fi



sleep 5
#cp -rp /home/condor/* /mnt/condor
#echo "/dev/mapper/wn-cvmfs    /mnt/cvmfs              ext4    defaults              0 0" >> /etc/fstab
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab
#chown -R cvmfs:cvmfs /mnt/cvmfs
#chown condor:condor /mnt/condor

chown -R $LV_1.$LV_1 /mnt/$LV_1
chown -R $LV_1.$LV_2 /mnt/$LV_2
#ls /cvmfs/nova.opensciencegrid.org

fi # of else






