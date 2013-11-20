modularit-cobbler Cookbook
==========================

Sets up a cobbler server for unattended SO deployments

By default it also creates a profile for base ModularIT installation. This profile uses external sources, so it should be only used on hosts with a fast Internet connection

Requirements
------------

Basically an RHEL/CentOS/Fedora server

Attributes
----------

Read the files, they are well documented (I hope)

Usage
-----

To setup a cobbler server, just add `recipe[modularit-cobbler::server]` to it's runlist. If you want to setup basic profiles for remote installation of CenTOS 6 and Debian 7, you can use `recipe[modularit-cobbler::defaultrepos]`

#### modularit-cobbler::default

Once the cobbler server is up and running, you can install a new ModularIT base system with the following command:

    koan --server 192.168.122.163 --virt --virt-name=test1 --profile=modularit-base-x86_64

Import CentOS 6 using rsync:

    cobbler import --path=rsync://rsync.cica.es/CentOS/6/os --name=centos6-x86_64 --arch=x86_64

LWRP
----

There are resource definitions for each cobbler entity:

#### modularit_cobbler_distro

Defines a Cobbler distro

    modularit_cobbler_distro "centos6-x86_64-remote" do
      action :add
      comment "CentOS 6 remote install"
      kernel "http://mirror.centos.org/centos/6/os/i386/images/pxeboot/vmlinuz"
      initrd "http://mirror.centos.org/centos/6/os/i386/images/pxeboot/initrd.img"
      arch "x86_64"
      ksmeta "tree=http://mirror.centos.org/centos/6/os/x86_64"
    end

#### modularit_cobbler_profile

Define a cobbler profile

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

#### modularit_cobbler_system

Define a cobbler system

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Kuko Armas <kuko@canarytek.com>
