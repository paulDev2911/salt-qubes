{% set cfg = pillar.get('sys-net', {}) %}
{% set mullvad = cfg.get('mullvad', {}) %}
{% set tpl_name = cfg.get('template', {}).get('name', 'fedora-42-net') %}

{% if grains['id'] == 'dom0' %}

sys-mullvad--create:
  qvm.vm:
    - name: {{ mullvad.get('name', 'sys-mullvad') }}
    - present:
      - template: {{ tpl_name }}
      - label: {{ mullvad.get('label', 'red') }}
      - class: AppVM
    - prefs:
      - label: {{ mullvad.get('label', 'red') }}
      - netvm: {{ mullvad.get('netvm', 'sys-firewall') }}
      - provides_network: {{ mullvad.get('provides_network', True) }}
      - memory: {{ mullvad.get('memory', 400) }}
      - maxmem: {{ mullvad.get('maxmem', 800) }}
      - vcpus: {{ mullvad.get('vcpus', 1) }}
      - autostart: {{ mullvad.get('autostart', False) }}
    - require:
      - qvm: {{ tpl_name }}

{% elif grains['id'] == mullvad.get('name', 'sys-mullvad') %}

{% set wg = mullvad.get('wireguard', {}) %}

sys-mullvad--wireguard-config:
  file.managed:
    - name: /home/user/se-got-wg-001.conf
    - source: salt://sys-net/files/wg-template.conf.j2
    - template: jinja
    - user: user
    - group: user
    - mode: 600
    - makedirs: True
    - context:
        private_key: {{ wg.get('private_key', '') }}
        address: {{ wg.get('address', '') }}
        dns: {{ wg.get('dns', '') }}
        peers: {{ wg.get('peers', []) }}

sys-mullvad--rc-local:
  file.managed:
    - name: /rw/config/rc.local
    - source: salt://sys-net/files/rc.local.j2
    - template: jinja
    - mode: 755
    - user: root
    - group: root
    - makedirs: True
    - context:
        wg_config_name: se-got-wg-001.conf
    - require:
      - file: sys-mullvad--wireguard-config

sys-mullvad--killswitch:
  file.managed:
    - name: /rw/config/qubes-firewall-user-script
    - source: salt://sys-net/files/qubes-firewall-user-script.j2
    - template: jinja
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

{% endif %}