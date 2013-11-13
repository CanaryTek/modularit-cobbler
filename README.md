modularit-template Cookbook
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

#### modularit-cobbler::default

Once the cobbler server is up and running, you can install a new ModularIT base system with the following command:

    koan --server 192.168.122.163 --virt --virt-name=test1 --profile=modularit-base-x86_64

Import CentOS 6 using rsync:

    cobbler import --path=rsync://rsync.cica.es/CentOS/6/os --name=centos6-x86_64 --arch=x86_64

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
