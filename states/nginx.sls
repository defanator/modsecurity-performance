{% set os = salt['grains.get']('os').lower() %}
{% set release = salt['grains.get']('lsb_distrib_codename', 'xenial') %}
{% set nginxver = salt['pillar.get']('versions:nginx') %}

NGINX Package Repository:
  pkgrepo.managed:
    - humanname: NGINX Package Repository
    - name: deb http://nginx.org/packages/mainline/{{ os }} {{ release }} nginx
    - dist: {{ release }}
    - file: /etc/apt/sources.list.d/nginx-oss.list
    - clean_file: True
    - gpgcheck: 1
    - keyid: '0xABF5BD827BD9BF62'
    - keyserver: ha.pool.sks-keyservers.net

NGINX Package:
  pkg.installed:
    - name: nginx
    - version: {{ nginxver }}-1~{{ release }}
    - require:
      - pkgrepo: NGINX Package Repository

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
  file.managed:
    - source: salt://files/etc/nginx/modsec/modsecurity.conf

/root/generate-servers.sh:
  file.managed:
    - source: salt://files/generate-servers.sh
    - mode: 755

/root/generate-hosts.sh:
  file.managed:
    - source: salt://files/generate-hosts.sh
    - mode: 755

Virtual servers conf:
  cmd.run:
    - name: /root/generate-servers.sh >/etc/nginx/conf.d/servers.conf
    - unless: test -e /etc/nginx/conf.d/servers.conf
    - require:
      - /root/generate-servers.sh

Update /etc/hosts:
  cmd.run:
    - name: /root/generate-hosts.sh >>/etc/hosts
    - unless: grep -q host100 /etc/hosts
    - require:
      - /root/generate-hosts.sh

NGINX service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/modsec/main.conf
      - file: /etc/nginx/modsec/modsecurity.conf
      - cmd: Virtual servers conf
