{% set cfg = pillar.get('personal', {}) %}
{% set vms = cfg.get('vms', {}) %}
{% set tpl_name = cfg.get('template', {}).get('name', 'fedora-42-personal') %}

{% if grains['id'] == 'dom0' %}

{% for vm_id, vm_cfg in vms.items() %}
personal-{{ vm_id }}--create:
  qvm.vm:
    - name: {{ vm_cfg.get('name', 'personal-' ~ vm_id) }}
    - present:
      - template: {{ tpl_name }}
      - label: {{ vm_cfg.get('label', 'blue') }}
    - prefs:
      - label: {{ vm_cfg.get('label', 'blue') }}
      - netvm: {{ vm_cfg.get('netvm', 'sys-firewall') }}
      - memory: {{ vm_cfg.get('memory', 4096) }}
      - maxmem: {{ vm_cfg.get('maxmem', 8192) }}
      - vcpus: {{ vm_cfg.get('vcpus', 2) }}
    - features:
      - set:
        - menu-items: "{{ vm_cfg.get('menu_items', '') }}"
    - require:
      - qvm: {{ tpl_name }}
{% endfor %}

{% endif %}