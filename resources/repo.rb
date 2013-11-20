## Cookbook Name:: modularit-cobbler
## Resource:: repo
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

## Manage Cobbler repos

actions :add, :remove

# Mandatory args
attribute :name, :kind_of => String, :name_attribute => true
attribute :mirror, :kind_of => String, :required => true

# Optional args
ARGS = %w[ apt_components apt_dists arch breed comment keep_updated parent rpm_list createrepo_flags environment mirror_locally priority yumopts ]


ARGS.each do |arg|
  attribute arg.to_sym, :kind_of => String
end

def initialize(*args)
  super
  @action = :add
end

