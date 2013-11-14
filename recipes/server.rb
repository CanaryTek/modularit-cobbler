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

## Modularit base distros
modularit_cobbler_distro "centos6-x86_64-remote" do
  action :add
  comment "CentOS 6 remote install"
  kernel "http://mirror.centos.org/centos/6/os/i386/images/pxeboot/vmlinuz"
  initrd "http://mirror.centos.org/centos/6/os/i386/images/pxeboot/initrd.img"
  arch "x86_64"
  ksmeta "tree=http://mirror.centos.org/centos/6/os/x86_64"
end
modularit_cobbler_distro "debian7-x86_64-remote" do
  action :add
  comment "Debian 7 remote install"
  kernel "http://debian.inode.at/debian/dists/Debian7.2/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux"
  initrd "http://debian.inode.at/debian/dists/Debian7.2/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz"
  breed "debian"
  os_version "wheezy"
  arch "x86_64"
  ksmeta "tree=http://debian.inode.at/debian/dists/Debian7.2/main/installer-amd64/ hostname=ftp.fr.debian.org directory=/debian suite=wheezy"
  kopts "serial console=ttyS0 console=tty0"
end

# Modularit base profiles
modularit_cobbler_profile "modularit-base-x86_64" do
  action :add
  comment "CentOS 6 modularit base"
  distro "centos6-x86_64-remote"
  kickstart "/var/lib/cobbler/kickstarts/modularit/modularit2_base.ks"
  virt_bridge "virbr0"
  virt_type "kvm"
  kopts "serial console=ttyS0,38400"
  kopts_post "console=ttyS0,38400"
end
modularit_cobbler_profile "modularit-debian-x86_64" do
  action :add
  comment "Debian 7 modularit base"
  distro "debian7-x86_64-remote"
  kickstart "/var/lib/cobbler/kickstarts/modularit/modularit_debian.seed" 
  virt_bridge "virbr0" 
  virt_type "kvm" 
  kopts "auto=yes console-setup/layoutcode=es netcfg/get_hostname=debian debian-installer/locale=es_ES text serial console=ttyS0,38400"
  kopts_post "console=ttyS0,38400"
end

