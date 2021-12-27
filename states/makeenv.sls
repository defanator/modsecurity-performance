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
      - libpcre2-dev
      - libpcre3-dev
      - libssl-dev
      - libtool
      - libxml2-dev
      - libyajl-dev
      - make
      - man-db
      - mercurial
      - ministat
      - net-tools
      - pkg-config
      - uwsgi-plugin-python
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
      wrkrev: {{ salt['pillar.get']('versions:wrk') }}
    - require:
      - Test user

prove configuration for test:
  file.managed:
    - user: test
    - name: /home/test/.proverc
    - contents: |
        -j16

/etc/motd:
  file.managed:
    - contents: |
        In order to extend this environment with a set of debug utilities,
        such as gdb, valgrind, systemtap, perf and others, please run:

            sudo salt-call state.apply debugenv
         
        Please note that this action will also install debug symbols
        for the current running kernel, it may take some time.
         
        Nikto web server security scanner tool is available for testing, e.g.:

            nikto -host localhost -root /modsec-off/
            nikto -host localhost -root /modsec-full/
         
