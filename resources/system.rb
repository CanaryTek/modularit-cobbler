## Cookbook Name:: modularit-cobbler
## Resource:: system
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

# Optional args
ARGS = %w[ profile image status kopts kopts_post ksmeta enable_gpxe proxy netboot_enabled kickstart comment virt_path virt_type virt_cpus virt_file_size virt_disk_driver virt_ram virt_auto_boot virt_pxe_boot power_type power_address power_user power_pass power_id hostname gateway name_servers name_servers_search ipv6_default_device ipv6_autoconfiguration mac_address mtu ip_address interface_type bonding interface_master bonding_master bonding_opts bridge_opts management static netmask subnet if_gateway dhcp_tag dns_name static_routes virt_bridge ipv6_address ipv6_secondaries ipv6_mtu ipv6_static_routes ipv6_default_gateway mgmt_classes mgmt_parameters boot_files fetchable_files template_files template_remote_kickstarts repos_enabled ldap_enabled ldap_type monit_enabled cnames interface delete_interface rename_interface ]

ARGS.each do |arg|
  attribute arg.to_sym, :kind_of => String
end

def initialize(*args)
  super
  @action = :add
end

