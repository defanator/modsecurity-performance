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
    vagrant@vagrant:~$ sudo su -l test
    test@vagrant:~$ ./perfrun.sh run
    test@vagrant:~$ ./perfrun.sh stats
    ```

## What is being tested

Currently three locations are being benchmarked on locally configured
nginx instance:

* `/modsec-off/` - proxies all requests to local server with no additional
processing

* `/modsec-light/` - proxies all requests to local server with libmodsecurity
turned on, but without any actual rules

* `/modsec-full/` - proxies all requests to local server with libmodsecurity
turned on and full OWASP CRS v3 loaded

Please refer to the [nginx.conf](https://github.com/defanator/modsecurity-performance/blob/master/states/files/etc/nginx/nginx.conf)
for the details.

## Batch benchmarking

If you want to run benchmark for a particular subset of libmodsecurity
changesets, this can be done in a following way:

    test@vagrant:~$ cat batchbench.revs 
    10c4f9b1b2476f71159fa5569d9238001760404c
    9e9db08b874fe7c1200aafd95fe6bccd41148ae5
    fa7973a4ef99b0d91122d16ffee51744288d037f
    2988c5bb07c4a5ad434855413f20fec11008c818
    63bef3d142b2ae25ed42d344c40729fb5f3d552e
    d9d702f401c870bf399d8cd5bc4ae212c7d52195

    test@vagrant:~$ ./batchbench.sh run
    [..]

    test@vagrant:~$ ./batchbench.sh stats
    ;rps_avg,latency_avg,workers_utime_avg,revision,date,commit_log
    530.57,787.49,17869.33,10c4f9b1b2476f71159fa5569d9238001760404c,2017-08-19 10:21:57 +0300,add a test for macro expansion in @rx
    533.27,719.25,17855.33,9e9db08b874fe7c1200aafd95fe6bccd41148ae5,2017-08-19 11:16:54 +0300,add @rx macro expansion test to list in Makefile
    29.81,1562.69,17968.00,fa7973a4ef99b0d91122d16ffee51744288d037f,2017-10-06 20:32:40 +0000,Removes a regex optimization added at #1536
    28.26,1528.49,17946.33,2988c5bb07c4a5ad434855413f20fec11008c818,2017-10-06 20:35:09 +0000,CHANGES: add info about #1536
    28.64,1495.39,17951.00,63bef3d142b2ae25ed42d344c40729fb5f3d552e,2017-10-03 20:50:02 +0000,Support to JSON stuff on serial logging
    633.89,680.80,17829.33,d9d702f401c870bf399d8cd5bc4ae212c7d52195,2018-01-03 09:49:20 -0300,Fix the debuglogs for the regression tests

Build logs and raw wrk output will be in the `batch/` directory.
Please note that `batchbench.sh` uses separate script for launching wrk -
[batchperfrun.sh](https://github.com/defanator/modsecurity-performance/blob/master/states/files/batchperfrun.sh)
(e.g. it uses extended request with additional headers, it only tests `/modsec-full` location,
and finally it uses more threads/connections for wrk).

## Important notes

Please adjust nginx configuration and wrk parameters according to your environment and available resources.
Default values (like `worker_processes 1` in nginx.conf) most likely won't meet your expectations in some scenarios.

## Sample results

Available on [wiki](https://github.com/defanator/modsecurity-performance/wiki).
