include:
  - nginx

/data/upload-app:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True

/data/upload-app/upload-app.ini:
  file.managed:
    - source: salt://files/upload-app/upload-app.ini
    - user: nginx
    - group: nginx
    - mode: 644
    - watch_in:
      - upload-app

/data/upload-app/upload-app.py:
  file.managed:
    - source: salt://files/upload-app/upload-app.py
    - user: nginx
    - group: nginx
    - mode: 755

upload-app systemd service:
  file.managed:
    - name: /lib/systemd/system/upload-app.service
    - mode: 0644
    - makedirs: True
    - source: salt://files/upload-app/upload-app.service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: upload-app systemd service

upload-app:
  service.running:
    - enable: True
