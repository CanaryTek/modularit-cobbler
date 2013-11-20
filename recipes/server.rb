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
  packages = [ "cobbler", "cobbler-web", "debmirror", "pykickstart", "fence-agents" ]
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

