OWASP CRS:
  git.latest:
    - name: https://github.com/SpiderLabs/owasp-modsecurity-crs.git
    - target: /etc/nginx/modsec/owasp-crs
    - rev: {{ salt['pillar.get']('versions:owasp-crs') }}

Default crs-setup.conf:
  file.symlink:
    - name: /etc/nginx/modsec/owasp-crs/crs-setup.conf
    - target: /etc/nginx/modsec/owasp-crs/crs-setup.conf.example
    - require:
      - OWASP CRS
