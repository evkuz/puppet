#!/bin/bash

#rpm -e osg-release
#rpm -Uvh http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el6-release-latest.rpm
yum clean all 
#--enablerepo=*
yum update -y
