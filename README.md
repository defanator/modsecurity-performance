# Purpose

This repository contains a number of configurations (represented
in SaltStack states and Vagrantfile descriptions) that can be used
to test performance of (lib)ModSecurity with various connectors
like ModSecurity-nginx.

## Prerequisites

 * Vagrant
 * your favorite virtualization plug-in for Vagrant

VirtualBox is known to work on MacOS/Linux-based laptops, while
KVM/libvirt is probably the best choice for servers.

## How to use

1. Adjust `pillars/versions.sls` if you want to build some custom
versions/revisions/branches of either ModSecurity or ModSecurity-nginx.

2. Prepare VM (could take some time as this step includes
compilation of all the prerequisites required for testing:
libmodsecurity and ModSecurity-nginx connector module):

    ```
    vagrant up
    ```

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

Currently there are three locations configured in nginx:

* `/modsec-off/` - proxies all requests to local server with no additional
processing

* `/modsec-light/` - proxies all requests to local server with libmodsecurity
turned on, but without any actual rules

* `/modsec-full/` - proxies all requests to local server with libmodsecurity
turned on and full OWASP CRS v3.0.0 loaded

## Sample results

Available on [wiki](https://github.com/defanator/modsecurity-performance/wiki).
