## Cookbook Name:: modularit-cobbler
## Resource:: profile
##
## Copyright 2013, CanaryTek
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

## Manage Cobbler profiles

actions :add, :remove

# Mandatory args
attribute :name, :kind_of => String, :name_attribute => true
attribute :distro, :kind_of => String, :required => true

# Optional args
ARGS = %w[ distro parent enable_gpxe enable_menu kickstart kopts kopts_post ksmeta proxy repos comment virt_auto_boot virt_cpus virt_file_size virt_disk_driver virt_ram depth virt_type virt_path virt_bridge dhcp_tag server name_servers name_servers_search mgmt_classes mgmt_parameters boot_files fetchable_files template_files template_remote_kickstarts clobber in_place ]

ARGS.each do |arg|
  attribute arg.to_sym, :kind_of => String
end

def initialize(*args)
  super
  @action = :add
end

