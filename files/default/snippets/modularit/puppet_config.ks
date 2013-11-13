$SNIPPET('modularit/modularit_name_changeme')

#if $getVar('puppet_server','') != '' and $getVar('modularit_name','') != ''
# Configure puppet_server
/usr/bin/perl -pi.bck -e "s/^#PUPPET_SERVER=.*/PUPPET_SERVER=\"$puppet_server\"/" /etc/sysconfig/puppet
# Configure modularit_name
/usr/bin/perl -pi.bck -e "s/^#PUPPET_EXTRA_OPTS=.*/PUPPET_EXTRA_OPTS=\"--waitforcert=60 --runinterval=120 --fqdn $modularit_name\"/" /etc/sysconfig/puppet

cat <<__EOB__ > /etc/puppet/puppet.conf
[main]
	vardir = /var/lib/puppet
	ssldir = \\$vardir/ssl
	pluginsync = true
	factpath = \\$vardir/lib/facter
__EOB__

#end if
#if $getVar('modularit_type','') != ''
# Configure modularit_type
echo $modularit_type > /etc/modularit-release
#end if
chkconfig puppet on

