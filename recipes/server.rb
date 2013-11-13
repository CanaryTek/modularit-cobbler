#
# Cookbook Name:: modularit-cobbler
# Recipe:: default
#
# Copyright 2013, CanaryTek
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "modularit-cobbler::default"

# Disable SELinux
case node['platform']
when "centos","redhat"
  bash "Workaround for http://tickets.opscode.com/browse/COOK-1210" do 
    code <<-EOH
      echo 0 > /selinux/enforce
    EOH
  end
end

# Distro specific settings
case node['platform_family']
when 'debian'
  packages = 'PLEASE_DEFINE'
  services = 'PLEASE_DEFINE'
when 'rhel','fedora'
  packages = [ "cobbler", "cobbler-web", "debmirror", "pykickstart" ]
  services = [ "cobblerd", "httpd" ]
else
  packages = 'PLEASE_DEFINE'
  services = 'PLEASE_DEFINE'
end

# Install needed packages
packages.each do |pkg|
  package pkg do
    action :install
  end
end

# Start needed services
services.each do |srv|
  service srv do
    action [ :start, :enable ]
  end
end

# Cobbler settings file
template "/etc/cobbler/settings" do
  source 'settings.erb'
  mode 00644
  notifies :reload, 'service[cobblerd]', :immediately
end

# ModularIT's cobbler kickstarts and snippets
[ "kickstarts", "snippets"]. each do |dir|
  remote_directory "/var/lib/cobbler/#{dir}/modularit" do
    source "#{dir}/modularit"
    owner "root"
    group "root"
    mode 00755
    files_mode 00755
    action :create
  end
end

# Create base CentOS 6 distro and profile
bash "create-base-centos6-profile" do
  code <<-EOH
    cobbler distro remove --name centos6-x86_64-remote
    cobbler distro add --name centos6-x86_64-remote --kernel http://mirror.centos.org/centos/6/os/i386/images/pxeboot/vmlinuz --initrd http://mirror.centos.org/centos/6/os/i386/images/pxeboot/initrd.img --arch x86_64 --ksmeta "tree=http://mirror.centos.org/centos/6/os/x86_64"

    cobbler profile remove --name modularit-base-x86_64
    cobbler profile add --name modularit-base-x86_64 --distro centos6-x86_64-remote --kickstart /var/lib/cobbler/kickstarts/modularit/modularit2_base.ks --virt-bridge virbr0 --virt-type qemu --kopts "serial console=ttyS0,115200" --kopts-post "console=ttyS0,115200"
  EOH
end

# Create base Debian 7 distro and profile
bash "create-base-debian7-profile" do
  code <<-EOH
    cobbler distro remove --name debian7-x86_64-remote
    cobbler distro add --name debian7-x86_64-remote --breed debian --os_version "wheezy" --arch x86_64 --ksmeta "tree=http://debian.inode.at/debian/dists/Debian7.1/main/installer-amd64/ hostname=ftp.fr.debian.org directory=/debian suite=wheezy" --kopts "serial console=ttyS0 console=tty0" --kernel http://debian.inode.at/debian/dists/Debian7.1/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux --initrd http://debian.inode.at/debian/dists/Debian7.1/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz

    cobbler profile remove --name modularit-debian-x86_64
    cobbler profile add --name modularit-debian-x86_64 --distro debian7-x86_64-remote --kickstart /var/lib/cobbler/kickstarts/modularit/modularit_debian.seed --virt-bridge virbr0 --virt-type qemu --kopts "auto=yes console-setup/layoutcode=es netcfg/get_hostname=debian debian-installer/locale=es_ES text serial console=ttyS0,115200" --kopts-post "console=ttyS0,115200"
  EOH
end



