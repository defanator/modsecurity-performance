/etc/security/limits.d/global-overrides.conf:
  file.managed:
    - mode: 0644
    - makedirs: True
    - contents: |
        * soft core unlimited
        * hard core unlimited
        * soft nofile 131072
        * hard nofile 131072

global systemd overrides:
  file.managed:
    - name: /etc/systemd/system.conf.d/global-overrides.conf
    - mode: 0644
    - makedirs: True
    - contents: |
        [Manager]
        DefaultLimitCORE=infinity
        DefaultLimitNOFILE=131072
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: global systemd overrides

kernel.core_pattern:
  sysctl.present:
    - value: /tmp/%e.%p.core

net.ipv4.ip_local_port_range:
  sysctl.present:
    - value: 1024 64999

net.ipv4.tcp_tw_reuse:
  sysctl.present:
    - value: 1

net.core.somaxconn:
  sysctl.present:
    - value: 32768
