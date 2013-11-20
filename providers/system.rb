#
# Cookbook Name:: modularit-cobbler
# Provider:: system
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
  Chef::Resource::ModularitCobblerSystem::ARGS.each do |arg|
    myargs += "--#{arg.tr("_","-")} '#{new_resource.send(arg)}' " if new_resource.send(arg)
  end
  # If profile exists, edit
  if system("cobbler profile find --name #{new_resource.name} | grep -q #{new_resource.name}")
    Chef::Log.info "Editing system #{new_resource.name} "
    command="edit"
  else
    Chef::Log.info "Creating system #{new_resource.name}"
    command="add"
  end
  converge_by("Creating system #{new_resource.name}") do
    cmd="cobbler system #{command} --name #{new_resource.name} #{myargs}"
    Chef::Log.debug "  cmd #{cmd}"
    system(cmd)
  end
end

action :remove do
  if system("cobbler system find --name #{new_resource.name} | grep -q #{new_resource.name}")
    system("cobbler system remove --name #{new_resource.name}")
  end
end

