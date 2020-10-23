#!/bin/bash
# git@git.jinr.ru:cloud-team/htcondor/puppet-master_foreman_19_1.git
#git remote add origin git@github.com:evkuz/pupet.git
# git push -u origin master
# fatal: remote origin already exists. 

# git@github.com:evkuz/puppet.git

#environments/production/modules/wn_osg/files/id_rsa

# get list of folder names which means environment 
ENV_PATH="/etc/puppetlabs/code/environments"
cd $ENV_PATH
ls -l 


git add environments/develop/manifests
git add environments/develop/modules/wn_osg
git add environments/develop/modules/fwall

git add environments/develop/modules/fwall_defined
git add environments/el7_develop/modules/wn_osg_el7

git add environments/production/modules/wn_osg

git add environments/master
