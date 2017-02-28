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

Heads of `v3/dev/parser` branches of both ModSecurity and ModSecurity-nginx
(as of 20170228):

```
$ cat pillars/versions.sls 
versions:
  - nginx: 1.11.10
  - libmodsecurity: v3/dev/parser
  - connector: v3/dev/parser

Summary for /modsec-off, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10      39445.56      46228.25      44283.87     43476.616     2184.7312
 latency (ms)
x  10           1.1          1.37          1.21         1.222   0.091627264

Summary for /modsec-light, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10       8071.25      11953.68      10634.85     10374.126     1200.2281
 latency (ms)
x  10          4.23          7.82             5         5.358     1.2109941

Summary for /modsec-full, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10         238.8        259.02        246.88       247.418     5.9640549
 latency (ms)
x  10        208.11        230.52        217.76       218.968     6.9131273
```

Head of `v3/master` branch of ModSecurity, head of `master` branch
of ModSecurity-nginx (as of 20170228):

```
$ cat pillars/versions.sls
versions:
  - nginx: 1.11.10
  - libmodsecurity: v3/master
  - connector: master

Summary for /modsec-off, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10       38136.4      47561.79      44300.42     43351.954     2743.1755
 latency (ms)
x  10          1.07           1.4          1.19         1.206   0.099911072

Summary for /modsec-light, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10      10120.76       12979.9      12727.41     12290.594     891.67524
 latency (ms)
x  10          3.88          5.02          3.98         4.128    0.34726871

Summary for /modsec-full, RPS (count):
    N           Min           Max        Median           Avg        Stddev
x  10        334.64        370.86        363.77       356.733     13.667706
 latency (ms)
x  10        142.49        158.27        147.04       148.176     5.8598297
```
