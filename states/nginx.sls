{% set os = salt['grains.get']('os').lower() %}
{% set release = salt['grains.get']('lsb_distrib_codename', 'focal') %}
{% set nginxver = salt['pillar.get']('versions:nginx') %}

include:
  - build

NGINX Package Repository:
  pkgrepo.managed:
    - humanname: NGINX Package Repository
    - name: deb http://nginx.org/packages/mainline/{{ os }} {{ release }} nginx
    - dist: {{ release }}
    - file: /etc/apt/sources.list.d/nginx-oss.list
    - clean_file: True
    - gpgcheck: 1
    - keyid: '0xABF5BD827BD9BF62'
    - keyserver: keyserver.ubuntu.com

NGINX Package:
  pkg.installed:
    - name: nginx
    - version: {{ nginxver }}-1~{{ release }}
    - require:
      - pkgrepo: NGINX Package Repository

NGINX empty default.conf:
  file.managed:
    - name: /etc/nginx/conf.d/default.conf
    - contents: ''
    - contents_newline: False
    - require:
      - NGINX Package

NGINX Debug Symbols:
  pkg.installed:
    - name: nginx-dbg
    - version: {{ nginxver }}-1~{{ release }}
    - require:
      - pkgrepo: NGINX Package Repository

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://files/etc/nginx/nginx.conf

/etc/nginx/modsec/main.conf:
  file.managed:
    - source: salt://files/etc/nginx/modsec/main.conf

/etc/nginx/modsec/modsecurity.conf:
  cmd.run:
    - name: cat /home/test/ModSecurity/modsecurity.conf-recommended | grep -v "^#" | strings | sed -e 's#^SecRuleEngine.*#SecRuleEngine On#' > /etc/nginx/modsec/modsecurity.conf
    - unless: test -e /etc/nginx/modsec/modsecurity.conf
    - require:
      - Build all

/etc/nginx/modsec/unicode.mapping:
  file.copy:
    - name: /etc/nginx/modsec/unicode.mapping
    - source: /home/test/ModSecurity/unicode.mapping
    - require:
      - Build all

/root/gencert.sh:
  file.managed:
    - source: salt://files/gencert.sh
    - mode: 0755

Create Self-Signed Certificate:
  cmd.run:
    - name: /root/gencert.sh localhost
    - cwd: /etc/nginx
    - unless: test -e /etc/nginx/localhost.pem
    - require:
      - /root/gencert.sh

NGINX service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - /etc/nginx/nginx.conf
      - /etc/nginx/modsec/main.conf
      - /etc/nginx/modsec/modsecurity.conf
      - /etc/nginx/modsec/unicode.mapping
    - require:
      - Create Self-Signed Certificate
