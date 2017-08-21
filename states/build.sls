include:
  - user

Build all:
  cmd.run:
    - name: make all
    - cwd: /home/test
    - runas: test
    - unless: test -e /home/test/ngx_http_modsecurity_module.so
    - require:
      - Test user

Symlink for wrk:
  file.symlink:
    - name: /usr/bin/wrk
    - target: /home/test/wrk/wrk
    - require:
      - Build all
