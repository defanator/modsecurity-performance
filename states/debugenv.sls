{% set release = salt['grains.get']('lsb_distrib_codename', 'yakkety') %}
{% set kernelrelease = salt['grains.get']('kernelrelease') %}

{% for repo_path in ['', '-updates', '-proposed'] %}
Ubuntu Debug Repository{{ repo_path }}:
  pkgrepo.managed:
    - humanname: repo{{ repo_path }}
    - name: 'deb http://ddebs.ubuntu.com/ {{ release }}{{ repo_path }} main restricted universe multiverse'
    - file: /etc/apt/sources.list.d/ddebs.list
    - enabled: True
    - gpgcheck: 1
    - keyid: '0xC8CAB6595FDFF622'
    - keyserver: hkps.pool.sks-keyservers.net
{% endfor %}

Debug packages:
  pkg.latest:
    - pkgs:
      - gdb
      - libc6-dbg
      - libc6-dbgsym
      - libcomerr2-dbgsym
      - libcurl4-dbg
      - libffi6-dbg
      - libgeoip1-dbgsym
      - libgmp10-dbgsym
      - libgnutls30-dbgsym
      - libgssapi-krb5-2-dbgsym
      - libgssapi3-heimdal-dbgsym
      - libhogweed4-dbgsym
      - libicu57-dbgsym
      - libidn11-dbgsym
      - libkeyutils1-dbgsym
      - libldap-2.4-2-dbg
      - liblzma5-dbgsym
      - libp11-kit0-dbgsym
      - libpcre3-dbg
      - librtmp1-dbgsym
      - libsasl2-2-dbgsym
      - libssl1.0.0-dbg
      - libssl1.0.0-dbgsym
      - libstdc++6-6-dbg
      - libsqlite3-0-dbg
      - libtasn1-6-dbgsym
      - libxml2-dbg
      - libyajl2-dbg
      - linux-image-{{ kernelrelease }}-dbgsym
      - linux-tools-{{ kernelrelease }}
      - systemtap
      - valgrind
      - zlib1g-dbg
    - require:
      - Ubuntu Debug Repository
      - Ubuntu Debug Repository-proposed
      - Ubuntu Debug Repository-updates

{% for group in ['stapusr', 'stapsys', 'stapdev'] %}
{{ group }} membership:
  group.present:
    - name: {{ group }}
    - addusers:
      - ubuntu
      - test
    - require:
      - Debug packages
{% endfor %}

Fix permissions for systemtap:
  cmd.run:
    - name: chmod 644 /boot/System.map-{{ kernelrelease }}
    - unless: test `stat -c '%a' /boot/System.map-{{ kernelrelease }}` = 644
    - require:
      - Debug packages
