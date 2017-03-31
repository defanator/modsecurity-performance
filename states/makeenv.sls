include:
  - user

Dependency packages:
  pkg.latest:
    - pkgs:
      - automake
      - autoconf
      - bison
      - curl
      - flex
      - g++
      - gcc
      - git
      - htop
      - libcurl4-openssl-dev
      - libgeoip-dev
      - libpcre3-dev
      - libtool
      - libxml2-dev
      - libyajl-dev
      - make
      - man
      - ministat
      - pkg-config
      - uwsgi-plugin-python
      - wrk
      - zlib1g-dev

Makefile:
  file.managed:
    - user: test
    - name: /home/test/Makefile
    - source: salt://files/Makefile.tmpl
    - template: jinja
    - context:
      nginxver: {{ salt['pillar.get']('versions:nginx') }}
      lmsrev: {{ salt['pillar.get']('versions:libmodsecurity') }}
      connectorrev: {{ salt['pillar.get']('versions:connector') }}
    - require:
      - Test user
