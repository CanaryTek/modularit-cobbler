## Cookbook Name:: modularit-cobbler
## Resource:: distro
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

## Manage Cobbler distros

actions :add, :remove

# Mandatory args
attribute :name, :kind_of => String, :name_attribute => true
attribute :kernel, :kind_of => String, :required => true
attribute :initrd, :kind_of => String, :required => true

# Optional args
ARGS = %w[ kopts kopts_post ksmeta arch breed os_version source_repos comment mgmt_classes boot_files ]

ARGS.each do |arg|
  attribute arg.to_sym, :kind_of => String
end

def initialize(*args)
  super
  @action = :add
end

