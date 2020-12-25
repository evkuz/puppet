#!/bin/bash
#
############ ATTENTION !!!! ###############
# cvmfs and condor  packages must be installed BEFORE applying this script
#
##########################################
#
# mount | grep "^/dev"

LVMD="/dev/vdb"
me=`basename "$0"`

SETUPLOG="/var/log/node_lvm_setup.log"

touch $SETUPLOG
cp /dev/null $SETUPLOG


echo "$(date +"%d-%m-%Y %T") Start running $me script" |& tee $SETUPLOG

# first check the list of LVMs
LVM_LINES="$(lvs -a -o +devices | wc -l )" # | grep $DEV $SWAP_LINES -lt 3 | wc -l)"

if [[ $LVM_LINES -ne "0" ]]; then
   echo "$(date +"%d-%m-%Y %T") YES ! LVM exists on $LVMD, so skip other LVM-related steps" |& tee $SETUPLOG
else
# if not exist we create it
#echo "SORRY ! LVM IS NOT exists on $DEV"

    pvcreate $LVMD
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [pvcreate $LVMD]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" >> $SETUPLOG
	fi
###################
   vgcreate wn /dev/vdb
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [wn $LVMD]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMD]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMD]" >> $SETUPLOG
	fi
##################
   lvcreate -n cvmfs -L20G wn
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n cvmfs -L20G wn]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L20G wn]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L20G wn]" >> $SETUPLOG
	fi
##################
   lvcreate -n condor -L150G wn
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n condor -L150G wn]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L150G wn]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L150G wn]" >> $SETUPLOG
	fi
#################
   mkfs.ext4 -L cvmfs /dev/wn/cvmfs
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >> $SETUPLOG
	fi
#################
   mkfs.ext4 -L condor /dev/wn/condor
 	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L condor /dev/wn/condor]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L condor /dev/wn/condor]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L condor /dev/wn/condor]" >> $SETUPLOG
	fi
#################
   mount /dev/wn/cvmfs /mnt/cvmfs
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/cvmfs /mnt/cvmfs]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/cvmfs /mnt/cvmfs]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/cvmfs /mnt/cvmfs]" >> $SETUPLOG
	fi
#################
   mount /dev/wn/condor /mnt/condor
	if [ $? -eq 0 ]; then
	  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/condor /mnt/condor]" >> $SETUPLOG
	else
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/condor /mnt/condor]" >&2
	  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/condor /mnt/condor]" >> $SETUPLOG
	fi
#################
fi # of else

echo "$(date +"%d-%m-%Y %T") Finishing script $me" |& tee $SETUPLOG
sleep 5

#cp -rp /home/condor/* /mnt/condor

#{ echo "/dev/mapper/wn-cvmfs    /mnt/cvmfs              ext4    defaults              0 0" >> /etc/fstab ;
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab ;
#chown -R cvmfs:cvmfs /mnt/cvmfs ;
#chown condor:condor /mnt/condor ;
#} >> $SETUPLOG
#ls /cvmfs/nova.opensciencegrid.org
