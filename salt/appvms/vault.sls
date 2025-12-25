{% set vault = pillar.get('appvms', {}).get('vault', {}) %}

{% if grains['id'] == 'dom0' %}

vault--create:
  qvm.vm:
    - name: {{ vault.get('name', 'personal-vault') }}
    - present:
      - template: {{ vault.get('template', 'debian-13-vault') }}
      - label: {{ vault.get('label', 'black') }}
    - prefs:
      - label: {{ vault.get('label', 'black') }}
      - netvm: {{ vault.get('netvm', '') }}
      - memory: {{ vault.get('memory', 400) }}
      - maxmem: {{ vault.get('maxmem', 800) }}
      - vcpus: {{ vault.get('vcpus', 1) }}
      - autostart: {{ vault.get('autostart', False) }}
    - features:
      - set:
        - menu-items: "{{ vault.get('menu_items', 'org.keepassxc.KeePassXC.desktop') }}"

{% endif %}