OWASP CRS v3.0.0:
  git.latest:
    - name: https://github.com/SpiderLabs/owasp-modsecurity-crs.git
    - target: /etc/nginx/modsec/owasp-crs
    - rev: v3.0.0

Default crs-setup.conf:
  file.symlink:
    - name: /etc/nginx/modsec/owasp-crs/crs-setup.conf
    - target: /etc/nginx/modsec/owasp-crs/crs-setup.conf.example
    - require:
      - OWASP CRS v3.0.0
