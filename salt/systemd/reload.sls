reload_systemd:
  module.run:
    - service.systemctl_reload: []
    - listen:
      - file: /etc/systemd/system/multi-user.target.wants/*