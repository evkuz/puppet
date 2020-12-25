#!/bin/bash
#
############ ATTENTION !!!! ###############
# cvmfs and condor  packages must be installed BEFORE applying this script
#
##########################################

LVMD="/dev/vdb"

SETUPLOG="/var/log/node_lvm_setup.log"

echo "$(date +"%d-%m-%Y %T") running init_lvm_el7.sh script" >> $SETUPLOG

pvcreate $LVMD
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [pvcreate $LVMD]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMD]" >> $SETUPLOG
fi
###################
vgcreate wn $LVMD
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [wn $LVMD]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMD]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMD]" >> $SETUPLOG
fi
##################
VNAME_1="cvmfs"
lvcreate -n $VNAME_1 -L20G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_1 -L20G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L20G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_1 -L20G wn]" >> $SETUPLOG
fi
##################
VNAME_2="home"
lvcreate -n $VNAME_2 -L150G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n $VNAME_2 -L150G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L150G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n $VNAME_2 -L150G wn]" >> $SETUPLOG
fi
#################
mkfs.ext4 -L $VNAME_1 /dev/wn/$VNAME_1
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L $VNAME_1 /dev/wn/$VNAME_1]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_1 /dev/wn/$VNAME_1]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_1 /dev/wn/$VNAME_1]" >> $SETUPLOG
fi
#################
mkfs.ext4 -L $VNAME_2 /dev/wn/$VNAME_2
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L $VNAME_2 /dev/wn/$VNAME_2]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_2 /dev/wn/$VNAME_2]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L $VNAME_2 /dev/wn/$VNAME_2]" >> $SETUPLOG
fi
#################
mount /dev/wn/$VNAME_1 /mnt/$VNAME_1
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/$VNAME_1 /mnt/$VNAME_1]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/$VNAME_1 /mnt/$VNAME_1]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/$VNAME_1 /mnt/$VNAME_1]" >> $SETUPLOG
fi
#################

mount /dev/wn/$VNAME_2 /$VNAME_2
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/$VNAME_2 /mnt/$VNAME_2]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/$VNAME_2 /mnt/$VNAME_2]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/$VNAME_2 /mnt/$VNAME_2]" >> $SETUPLOG
fi
#################
sleep 5
#cp -rp /home/condor/* /mnt/condor

#{ echo "/dev/mapper/wn-cvmfs    /mnt/cvmfs              ext4    defaults              0 0" >> /etc/fstab ;
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab ;
#chown -R cvmfs:cvmfs /mnt/cvmfs ;
#chown condor:condor /mnt/condor ;
#} >> $SETUPLOG
#ls /cvmfs/nova.opensciencegrid.org
