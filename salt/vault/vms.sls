{% set cfg = pillar.get('vault', {}) %}
{% set vm = cfg.get('vm', {}) %}
{% set tpl_name = cfg.get('template', {}).get('name', 'debian-13-vault') %}

{% if grains['id'] == 'dom0' %}

vault-vm--create:
  qvm.vm:
    - name: {{ vm.get('name', 'personal-vault') }}
    - present:
      - template: {{ tpl_name }}
      - label: {{ vm.get('label', 'black') }}
    - prefs:
      - label: {{ vm.get('label', 'black') }}
      - netvm: {{ vm.get('netvm', '') }}
      - memory: {{ vm.get('memory', 400) }}
      - maxmem: {{ vm.get('maxmem', 800) }}
      - vcpus: {{ vm.get('vcpus', 1) }}
      - autostart: {{ vm.get('autostart', False) }}
    - features:
      - set:
        - menu-items: "{{ vm.get('menu_items', '') }}"
    - require:
      - qvm: {{ tpl_name }}

{% endif %}