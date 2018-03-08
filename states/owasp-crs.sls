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

OWASP CRS patch from PR 995:
  file.managed:
    - name: /etc/nginx/modsec/owasp-crs/995.patch
    - source: https://github.com/SpiderLabs/owasp-modsecurity-crs/pull/995.patch
    - source_hash: 767bb6156ce286f9d17069905feeac5f
    - require:
      - OWASP CRS

OWASP CRS patch from PR 995 apply:
  cmd.run:
    - name: cd /etc/nginx/modsec/owasp-crs/ && patch -p1 < 995.patch && touch 995.patch.applied
    - unless: test -e /etc/nginx/modsec/owasp-crs/995.patch.applied
    - require:
      - OWASP CRS
