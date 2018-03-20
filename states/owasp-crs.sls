OWASP CRS:
  git.latest:
    - name: https://github.com/SpiderLabs/owasp-modsecurity-crs.git
    - target: /etc/nginx/modsec/owasp-crs
    - rev: {{ salt['pillar.get']('versions:owasp-crs') }}

Default crs-setup.conf:
  cmd.run:
    - name: cd /etc/nginx/modsec/owasp-crs/ && cat crs-setup.conf.example | sed -e 's/^SecCollectionTimeout/#SecCollectionTimeout/g' > crs-setup.conf
    - unless: test -e /etc/nginx/modsec/owasp-crs/crs-setup.conf
    - require:
      - OWASP CRS
