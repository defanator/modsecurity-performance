{% set release = salt['grains.get']('lsb_distrib_codename', 'xenial') %}
{% set kernelrelease = salt['grains.get']('kernelrelease') %}
{% set virtual = salt['grains.get']('virtual') %}
{% set baseuser = 'vagrant' %}

{% if grains['os'] == 'Ubuntu' %}
{% for repo_path in ['', '-updates', '-proposed'] %}
Ubuntu Debug Repository{{ repo_path }}:
  pkgrepo.managed:
    - humanname: repo{{ repo_path }}
    - name: 'deb http://ddebs.ubuntu.com/ {{ release }}{{ repo_path }} main restricted universe multiverse'
    - file: /etc/apt/sources.list.d/ddebs.list
    - enabled: True
    - gpgcheck: 1
    - keyid: '0xC8CAB6595FDFF622'
    - keyserver: ha.pool.sks-keyservers.net
{% endfor %}
{% endif %}

Debug packages:
  pkg.latest:
    - pkgs:
      - gdb
      - libc6-dbg
{% if grains['os'] == 'Ubuntu' %}
      - libc6-dbgsym
      - libcomerr2-dbg
      - libcurl4-dbg
      - libffi6-dbg
      - geoip-dbg
      - libgmp10-dbgsym
      - libgssapi-krb5-2-dbgsym
      - libgssapi3-heimdal-dbgsym
      - libhogweed4-dbgsym
      - libicu55-dbgsym
      - libidn11-dbgsym
      - keyutils-dbg
      - libldap-2.4-2-dbg
      - liblzma5-dbgsym
      - libp11-kit0-dbgsym
      - libpcre3-dbg
      - librtmp1-dbgsym
      - libssl1.0.0-dbg
      - libstdc++6-5-dbg
      - libsqlite3-0-dbg
      - libtasn1-6-dbgsym
      - libxml2-dbg
      - libyajl2-dbg
      - linux-image-{{ kernelrelease }}-dbgsym
      - linux-tools-{{ kernelrelease }}
      - zlib1g-dbg
{% endif %}
      - systemtap
      - valgrind
{% if grains['os'] == 'Ubuntu' %}
    - require:
      - Ubuntu Debug Repository
      - Ubuntu Debug Repository-proposed
      - Ubuntu Debug Repository-updates
{% endif %}

{% for group in ['stapusr', 'stapsys', 'stapdev'] %}
{{ group }} membership:
  group.present:
    - name: {{ group }}
    - addusers:
      - {{ baseuser }}
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
