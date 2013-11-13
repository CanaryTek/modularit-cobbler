# Base kickstart
# Kuko Armas <kuko@canarytek.com>

#platform=x86, AMD64, or Intel EM64T
## In this section we only have settings specific to the installation
# Use text mode install
text
# Reboot after installation
reboot

# Install OS instead of upgrade
install 

# System config is included in the base_config.ks
$SNIPPET('modularit/base_config.ks')

# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
#$yum_repo_stanza
repo --name=ctos6 --baseurl=http://mirror.centos.org/centos/6/os/x86_64
repo --name=updates --baseurl=http://mirror.centos.org/centos/6/updates/x86_64
#repo --name=extras --baseurl=http://mirror.centos.org/centos/6/extras/x86_64
repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/6/x86_64
#repo --name=rpmforge --baseurl=http://apt.sw.be/redhat/el6/en/x86_64/rpmforge
#repo --name=modularit --baseurl=ftp://ftp.modularit.org/repos/centos/6/i386

#if $getVar("nopart","no") == "no"
$SNIPPET('modularit/autopart.ks')
#end if

%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')

# Enable installation monitoring
$SNIPPET('pre_anamon')

# Base packages
$SNIPPET('modularit/base_packages.ks')

# Additional packages for modularit_type
$SNIPPET('modularit/modularit_packages.ks')

%post
# FIXME: Set SELinux to permissive mode
fpath=/etc/selinux/config
cp $fpath $fpath.orig
cat $fpath.orig | sed 's/^SELINUX=.*/SELINUX=permissive/' > $fpath

$SNIPPET('log_ks_post')
# Start yum configuration 
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Puppet ModularIT
$SNIPPET('modularit/puppet_config.ks')
# Start final steps
$kickstart_done
# End final steps
