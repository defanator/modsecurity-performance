Test user:
  user.present:
    - name: test
    - empty_password: True
    - shell: /bin/bash

sudo for test user:
  file.managed:
    - name: /etc/sudoers.d/01-sudo-for-test
    - mode: 0440
    - contents: test ALL=(ALL) NOPASSWD:ALL
