{% if grains['os'] != 'CentOS' %}    
saltpymodules:
  pkg.installed:
    - pkgs:
      - python-docker
      - python-m2crypto
{% endif %}

salt_bootstrap:
  file.managed:
    - name: /usr/sbin/bootstrap-salt.sh
    - source: salt://salt/scripts/bootstrap-salt.sh
    - mode: 755

etc_salt_dirs:
  file.managed:
    - name: /etc/salt/
    - owner: root
    - group: root
    - dir_mode: 770
    - file_mode: 660
    - recurse:
      - user
      - group
      - mode
    - onlyif: __salt__['pkg.version']('salt-minion')