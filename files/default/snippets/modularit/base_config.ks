# System config
# Kuko Armas <kuko@canarytek.com>

# System authorization information
auth  --useshadow  --enablemd5
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard es
# System language
lang en_US.UTF-8
# Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --permissive
# Do not configure the X Window System
skipx
# System timezone
timezone --utc Atlantic/Canary

# Network information
# In profile based installs, use generic name
#if $getVar("system_name","") == ""
network --bootproto=dhcp --device=eth0 --onboot=on --hostname=ModularIT
#else
$SNIPPET('network_config')
#end if

