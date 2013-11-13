# Common base packages
# Kuko Armas <kuko@canarytek.com>

## DON'T TOUCH THIS!!! (unless you know what you are doing...)
%packages --nobase
$SNIPPET('func_install_if_enabled')
@core

## Additional base packages
cronie
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
file
openssh-server
openssh-clients

mdadm
postfix
screen
wireshark
nmap
gnupg
kernel

# Ruby
ruby
ruby-rdoc

# Yum
yum-priorities
yum-downloadonly
yum-protect-packages
yum-security

# Additional server packages
epel-release
# For PICA alarms
libmcrypt
perl-Config-Simple
#lshw

