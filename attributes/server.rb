# Author:: Kuko Armas
# Cookbook Name:: modularit-cobbler
# Attribute:: server

## Configration for cobbler settings file. It's a YAML file
# Cobbler "server" setting
default['cobbler']['server']['name'] = "cobbler.example.com"
# When cobbler finishes installing a system, it can notify by email. This are the related config settings
default['cobbler']['server']['build_reporting_enabled'] = "1"
default['cobbler']['server']['build_reporting_sender'] = "cobbler@example.com"
default['cobbler']['server']['build_reporting_email'] = [ 'noc@example.com' ]
default['cobbler']['server']['build_reporting_smtp_server'] = "localhost"
default['cobbler']['server']['build_reporting_subject'] = "Cobbler Report"
# Default root password for installed systems. Can be created with "openssl passwd -1". Default: cobbler
default['cobbler']['server']['default_password_crypted'] = "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."

# Various defaults for VM
default['cobbler']['server']['default_virt_bridge'] =" virbr0"
default['cobbler']['server']['default_virt_file_size'] = "5"
default['cobbler']['server']['default_virt_ram'] = "512"
default['cobbler']['server']['default_virt_type'] = "qemu"
default['cobbler']['server']['enable_gpxe'] = "0"

