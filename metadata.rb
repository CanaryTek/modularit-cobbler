maintainer        "Kuko Armas"
maintainer_email  "kuko@canarytek.com"
license           "Apache 2.0"
description       "Installs and configures cobbler"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"
recipe            "modularit-cobbler", "Installs and configures cobbler"

%w{apt yum}.each do |pkg|
  depends pkg
end

%w{redhat centos}.each do |os|
  supports os
end
