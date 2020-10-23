#!/bin/bash

filename="/etc/condor/condor_config"
newfilename="/etc/condor/condor_config_last"

# test 100 -gt 99 && echo "Yes, that's true." || echo "No, that's false."

echo "checking ${filename}..."

test -L $filename 
# && echo "Yes, it's a symlink to a file." || echo "No, that's NOT a symlink"

if [ $? -eq 0 ]
then
  echo  "Yes, it's a symlink to a file." 
  echo  "Now check that condor is running"
  service="condor"
  if (( $(ps -ef | grep -v grep | grep condor | wc -l) > 0 ))
	then
#		echo "condor is running!!! so restart"
               echo "condor is running!!! so do nothing"
#                service $service restart
	else
	#/etc/init.d/$service start
        echo "condor is NOT running!!! so start"
	echo "Host $HOSTNAME starting $service"
	service $service start
  fi

else
  echo "No, the source file is NOT a symlink, so make a backup of it"
  # but first check for backup existence
   test -L $newfilename
      if [ $? -eq 0 ]
        then
           echo  "Oops, backup file  is a symlink to a file. So delete it"
           rm -f $newfilename
        else
            echo "The backup file  is already exists, so do nothing"
      fi

  \cp $filename $newfilename # exclude "say yes" 
 # first delete target file as we have backup
  rm -f $filename
 # and NOW create a symlink
  ln -s /nfs/condor/condor-etc/condor_config.global /etc/condor/condor_config
  #condor_reconfig
  service condor restart
fi






#test -L $filename && echo "Yes, it's regular file." || echo "No, that's false."

