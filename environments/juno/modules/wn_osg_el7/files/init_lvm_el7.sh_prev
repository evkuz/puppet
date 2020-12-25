#!/bin/bash
#
############ ATTENTION !!!! ###############
# cvmfs and condor  packages must be installed BEFORE applying this script
#
##########################################


SETUPLOG="/var/log/node_lvm_setup.log"
CVMFS_SZ="20"
HTC_SZ="150"
LVMDISK="/dev/vdb"

touch $SETUPLOG
cp /dev/null $SETUPLOG



echo "$(date +"%d-%m-%Y %T") running init_lvm_el7_juno.sh script" >> $SETUPLOG

pvcreate $LVMDISK
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [pvcreate $LVMDISK]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMDISK]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate $LVMDISK]" >> $SETUPLOG
fi
###################
vgcreate wn $LVMDISK
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [wn $LVMDISK]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMDISK]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [wn $LVMDISK]" >> $SETUPLOG
fi
##################
lvcreate -n cvmfs -L${CVMFS_SZ}G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n cvmfs -L${CVMFS_SZ}G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L${CVMFS_SZ}G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L${CVMFS_SZ}G wn]" >> $SETUPLOG
fi
##################
lvcreate -n condor -L${HTC_SZ}G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n condor -L${HTC_SZ}G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L${HTC_SZ}G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L${HTC_SZ}G wn]" >> $SETUPLOG
fi
#################
mkfs.ext4 -L cvmfs /dev/wn/cvmfs
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L cvmfs /dev/wn/cvmfs]" >> $SETUPLOG
fi
#################
mkfs.ext4 -L condor /dev/wn/condor
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mkfs.ext4 -L condor /dev/wn/condor]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L condor /dev/wn/condor]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mkfs.ext4 -L condor /dev/wn/condor]" >> $SETUPLOG
fi
#################
mount /dev/wn/cvmfs /mnt/cvmfs
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/cvmfs /mnt/cvmfs]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/cvmfs /mnt/cvmfs]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/cvmfs /mnt/cvmfs]" >> $SETUPLOG
fi
#################
mount /dev/wn/condor /mnt/condor
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [mount /dev/wn/condor /mnt/condor]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/condor /mnt/condor]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [mount /dev/wn/condor /mnt/condor]" >> $SETUPLOG
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
