#!/bin/bash
pvcreate /dev/vdb
vgcreate wn /dev/vdb
lvcreate -n cvmfs -L33G wn
lvcreate -n condor -L280G wn
mkfs.ext4 -L cvmfs /dev/wn/cvmfs
mkfs.ext4 -L condor /dev/wn/condor
mount /dev/wn/cvmfs /mnt/cvmfs
mount /dev/wn/condor /mnt/condor
sleep 5
cp -rp /home/condor/* /mnt/condor
#echo "/dev/mapper/wn-cvmfs    /mnt/cvmfs              ext4    defaults              0 0" >> /etc/fstab
#echo "/dev/mapper/wn-condor   /mnt/condor             ext4    defaults              0 0" >> /etc/fstab
chown -R cvmfs:cvmfs /mnt/cvmfs
chown condor:condor /mnt/condor
ls /cvmfs/nova.opensciencegrid.org
