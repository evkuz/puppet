#!/bin/bash
#
############ ATTENTION !!!! ###############
# cvmfs and condor  packages must be installed BEFORE applying this script
#
##########################################


SETUPLOG="/var/log/node_lvm_setup.log"

echo "$(date +"%d-%m-%Y %T") running init_lvm_el7.sh script" >> $SETUPLOG

pvcreate /dev/vdc 
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [pvcreate /dev/vdc]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate /dev/vdc]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [pvcreate /dev/vdc]" >> $SETUPLOG
fi
###################
vgcreate wn /dev/vdc
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [wn /dev/vdc]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [wn /dev/vdc]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [wn /dev/vdc]" >> $SETUPLOG
fi
##################
lvcreate -n cvmfs -L50G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n cvmfs -L50G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L50G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n cvmfs -L50G wn]" >> $SETUPLOG
fi
##################
lvcreate -n condor -L300G wn
if [ $? -eq 0 ]
then
  echo "$(date +"%d-%m-%Y %T") Successfully [lvcreate -n condor -L300G wn]" >> $SETUPLOG
else
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L300G wn]" >&2
  echo "$(date +"%d-%m-%Y %T") Could not [lvcreate -n condor -L300G wn]" >> $SETUPLOG
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
