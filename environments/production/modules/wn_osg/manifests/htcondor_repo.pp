# Install HTCondor repository from wisconsin team

class wn_osg::htcondor_repo {
#
# Сцуко ОЧЕНЬ ВАЖНО !!!!
# Указываем ТОЛЬКО имя репозитория, БЕЗ расширения *.repo
yumrepo {'htcondor-stable-rhel6':
	ensure => present,
	enabled => 1,
	descr => "Native HTCondor repo",
	# Раньше работало и без priority
	priority => 10,
	gpgcheck => 1,
	gpgkey   => "https://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor",
	#baseurl => "https://research.cs.wisc.edu/htcondor/yum/stable/rhel6"
	baseurl  => "https://research.cs.wisc.edu/htcondor/yum/stable/8.8/rhel6",

     }#yumrepo 'htcondor-stable-rhel6'

}
