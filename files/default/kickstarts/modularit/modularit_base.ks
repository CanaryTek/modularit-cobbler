#
# Common config
# Miguel Armas <kuko@canarytek.com>
#
# The root password is: "passwd.root"

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard es
# System language
lang en_US.UTF-8
# Use network installation
url --url=http://mirror.centos.org/centos/5/os/i386
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
#$yum_repo_stanza
repo --name=ctos5 --baseurl=http://mirror.centos.org/centos/5/os/i386
repo --name=updates --baseurl=http://mirror.centos.org/centos/5/updates/i386
#repo --name=extras --baseurl=http://mirror.centos.org/centos/5/extras/i386
repo --name=epel --baseurl=http://download.fedora.redhat.com/pub/epel/5/i386
#repo --name=rpmforge --baseurl=http://apt.sw.be/redhat/el5/en/i386/rpmforge
#repo --name=modularit --baseurl=ftp://ftp.modularit.org/repos/centos/5/i386

# Network information
# In profile based installs, use generic name
#if $getVar("system_name","") == ""
network --bootproto=dhcp --device=eth0 --onboot=on --hostname=ModularIT
#else
$SNIPPET('network_config')
#end if
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --permissive
# Do not configure the X Window System
skipx
# System timezone
timezone --utc Atlantic/Canary
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
#autopart

#
# Disk partitions
# Miguel Armas <kuko@canarytek.com>
#

# Disk configuration
clearpart --all 
part /boot --fstype "ext3" --size=1024
part pv.01 --size 3000 --grow --maxsize=1800000
volgroup sys pv.01
logvol /var --vgname=sys --size=1024 --name=dom0_var --fstype=ext3
logvol / --vgname=sys --size=1536 --name=dom0_root --fstype=ext3
logvol /opt --vgname=sys --size=512 --name=dom0_opt --fstype=ext3
logvol swap --vgname=sys --recommended --name=swap --fstype=swap

%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')

#
# Packages
# Miguel Armas <kuko@canarytek.com>
#

## DON'T TOUCH THIS!!! (unless you know what you are doing...)
%packages --nobase
$SNIPPET('func_install_if_enabled')
@core

## Additional base packages
kernel
vixie-cron
crontabs
elinks
vim-enhanced
ntp
mtr
telnet
lsof
vconfig
usbutils
sos
smartmontools
rsync
parted
man
man-pages
logrotate
lftp
irqbalance

mdadm
exim
mysql
perl-DBI
postgresql-libs
screen
wireshark
nmap
aide
gnupg

# Ruby
ruby
ruby-rdoc

# Yum
yum-priorities
yum-downloadonly
yum-protect-packages
yum-security

# Additional server packages
#epel-release
#nut
#nut-client
puppet
# For PICA alarms
libmcrypt
#rpmforge-release
#perl-Config-Simple
#lshw

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
