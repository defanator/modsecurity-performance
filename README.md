# About

This repository contains a number of configurations (represented
in SaltStack states and Vagrantfile descriptions) that can be used
to test performance of
[ModSecurity](https://github.com/SpiderLabs/ModSecurity)
with various connectors, primarily
[ModSecurity-nginx](https://github.com/SpiderLabs/ModSecurity-nginx).

## Prerequisites

 * [Vagrant](https://www.vagrantup.com/)
 * your favorite virtualization plug-in for Vagrant

[VirtualBox](https://www.virtualbox.org/)
is known to work on MacOS/Linux-based laptops, while
[KVM/libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)
is probably the best choice for servers.

## How to use

1. Adjust
[pillars/versions.sls](https://github.com/defanator/modsecurity-performance/blob/master/pillars/versions.sls)
if you want to build some custom versions/revisions/branches
of either ModSecurity or ModSecurity-nginx.

2. Prepare VM (could take some time as this step includes
compilation of all the prerequisites required for testing:
libmodsecurity and ModSecurity-nginx connector module):

    ```
    vagrant up
    ```

    For the reference:

    * on libvirt-based 12-core VM (backed by bare-metal server with 24-core
Xeon E5645 2.4Ghz) provisioning takes about 7 minutes
    * on VirtualBox-based 2-core VM (backed by early 2015 MBP A1502 2-core
i5 2.9GHz) provisioning takes about 8.5 minutes

3. Log in into the VM:

    ```
    vagrant ssh
    ```

4. Run a set of performance tests and get a summary:

    ```
    cd /srv/salt/files
    ./perfrun.sh run
    ./perfrun.sh stats
    ```

## What is being tested

Currently three locations are being benchmarked on locally configured
nginx instance:

* `/modsec-off/` - proxies all requests to local server with no additional
processing

* `/modsec-light/` - proxies all requests to local server with libmodsecurity
turned on, but without any actual rules

* `/modsec-full/` - proxies all requests to local server with libmodsecurity
turned on and full OWASP CRS v3.0.0 loaded

Please refer to the [nginx.conf](https://github.com/defanator/modsecurity-performance/blob/master/states/files/etc/nginx/nginx.conf)
for the details.

## Sample results

Available on [wiki](https://github.com/defanator/modsecurity-performance/wiki).
