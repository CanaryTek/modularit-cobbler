ModularIT Templates
-------------------

These are the modularit templates for system installation

Variables
---------

  * modularit_type: sets the modularit host type
  * nopart: if set to "yes", the installation will stop in the partition step for manual partitioning

Profiles
--------

  * modularit-base: base modularit system. ALL modularit types are based in this. Most of themm sill be built from this one using chef
  * modularit-dom0: A virtualization server. It's basically a modularit-base with the virtualization addons. Since it's a phisicall server, it also contains some differences (no serial console, etc) 
