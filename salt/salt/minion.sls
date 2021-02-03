{% from 'salt/map.jinja' import COMMON with context %}
{% from 'salt/map.jinja' import UPGRADECOMMAND with context %}
{% from 'salt/map.jinja' import SALTVERSION %}
{% from 'salt/map.jinja' import INSTALLEDSALTVERSION %}

include:
  - salt
  - systemd.reload

install_salt_minion:
  cmd.run:
    - name: |
        exec 0>&- # close stdin
        exec 1>&- # close stdout
        exec 2>&- # close stderr
        nohup /bin/sh -c '{{ UPGRADECOMMAND }}' &
    - onlyif: test "{{INSTALLEDSALTVERSION}}" != "{{SALTVERSION}}"

salt_minion_package:
  pkg.installed:
    - pkgs:
      - {{ COMMON }}
      - salt-minion
    - hold: True
    - onlyif: test "{{INSTALLEDSALTVERSION}}" == "{{SALTVERSION}}"

salt_minion_service:
  service.running:
    - name: salt-minion
    - enable: True
    - onlyif: test "{{INSTALLEDSALTVERSION}}" == "{{SALTVERSION}}"
    - watch:
      - module: reload_systemd
      - file: salt_minion_systemd

salt_minion_systemd:
  file.managed:
    - name: /etc/systemd/system/multi-user.target.wants/salt-minion.service
    - source: salt://salt/systemd/salt-minion.service
    - onlyif: test "{{INSTALLEDSALTVERSION}}" == "{{SALTVERSION}}"