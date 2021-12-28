{% set release = salt['grains.get']('lsb_distrib_codename', 'focal') %}
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
    - keyserver: keyserver.ubuntu.com
{% endfor %}
{% endif %}

Debug packages:
  pkg.latest:
    - pkgs:
      - gdb
      - libc6-dbg
{% if grains['os'] == 'Ubuntu' %}
      - keyutils-dbgsym
      - libasn1-8-heimdal-dbgsym
      - libbrotli1-dbgsym
      - libcom-err2-dbgsym
      - libcrypt1-dbgsym
#     - libcurl4-dbgsym
      - libffi7-dbgsym
      - libgcc-s1-dbgsym
      - libgeoip1-dbgsym
      - libgmp10-dbgsym
      - libgssapi3-heimdal-dbgsym
      - libhcrypto4-heimdal-dbgsym
      - libheimbase1-heimdal-dbgsym
      - libheimntlm0-heimdal-dbgsym
      - libhogweed5-dbgsym
      - libidn2-0-dbgsym
      - libicu66-dbgsym
      - libkeyutils1-dbgsym
      - libkrb5-dbg
      - libldap-2.4-2-dbgsym
      - libnettle7-dbgsym
      - libnghttp2-14-dbgsym
#     - libnss-systemd-dbgsym
      - libssl1.1-dbgsym
      - libsqlite3-0-dbgsym
      - libidn11-dbgsym
      - liblzma5-dbgsym
      - libp11-kit0-dbgsym
      - libpcre2-8-0-dbgsym
      - libpcre2-16-0-dbgsym
      - libpcre2-32-0-dbgsym
      - libpcre3-dbg
      - libpsl5-dbgsym
      - libroken18-heimdal-dbgsym
      - librtmp1-dbgsym
      - libsasl2-2-dbgsym
      - libsasl2-modules-dbgsym
      - libsasl2-modules-db-dbgsym
      - libssh-4-dbgsym
      - libstdc++6-dbgsym
      - libtasn1-6-dbgsym
      - libunistring2-dbgsym
      - libwind0-heimdal-dbgsym
      - libxml2-dbgsym
      - libyajl2-dbgsym
      - zlib1g-dbgsym
      - linux-image-{{ kernelrelease }}-dbgsym
      - linux-tools-{{ kernelrelease }}
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
