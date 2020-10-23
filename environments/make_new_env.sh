#!/bin/bash

NEW_ENV="juno"
MODULE="wn_osg_el7"
cd /etc/puppetlabs/code/environments/
mkdir $NEW_ENV
cd ./$NEW_ENV
mkdir modules
mkdir manifests
cd ./modules
mkdir $MODULE
cd ./$MODULE
mkdir files
mkdir manifests
mkdir templates

chown -R puppet.root ./$NEW_ENV

