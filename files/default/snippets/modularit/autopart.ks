# Automatic partitions
# Kuko Armas <kuko@canarytek.com>

# Be safe, only use first disks
#ignoredisk --only-use=sda

# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Disk configuration
clearpart --all 
part /boot --fstype "ext4" --size=1024
part pv.01 --size 3000 --grow --maxsize=1800000
volgroup sys pv.01
logvol /var --vgname=sys --size=1024 --name=var --fstype=ext4
logvol / --vgname=sys --size=1536 --name=root --fstype=ext4
logvol /opt --vgname=sys --size=512 --name=opt --fstype=ext4
logvol swap --vgname=sys --size=512 --name=swap --fstype=swap

