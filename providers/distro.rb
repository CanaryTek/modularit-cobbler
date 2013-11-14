#
# Cookbook Name:: modularit-cobbler
# Provider:: distro
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

def whyrun_supported?
  true
end

action :add do
  myargs=""
  command=""
  # Handle optional arguments
  Chef::Resource::ModularitCobblerDistro::ARGS.each do |arg|
    myargs += "--#{arg.tr("_","-")} '#{new_resource.send(arg)}' " if new_resource.send(arg)
  end
  # If distro exists, edit
  if system("cobbler distro find --name #{new_resource.name} | grep -q #{new_resource.name}")
    Chef::Log.info "Distro #{new_resource.name} already exist. To "
    command="edit"
  else
    Chef::Log.info "Creating distro #{new_resource.name}"
    command="add"
  end
  converge_by("Creating distro #{new_resource.name}") do
    cmd="cobbler distro #{command} --name #{new_resource.name} --kernel #{new_resource.kernel} --initrd #{new_resource.initrd} #{myargs}"
    Chef::Log.debug "  cmd #{cmd}"
    system(cmd)
  end
end

action :remove do
  if system("cobbler distro find --name #{new_resource.name} | grep -q #{new_resource.name}")
    system("cobbler distro remove --name #{new_resource.name}")
  end
end

