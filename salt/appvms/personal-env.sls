{% set appvms = pillar.get('appvms', {}).get('personal', {}) %}

{% if grains['id'] == 'dom0' %}

{% set dev = appvms.get('dev', {}) %}
personal-dev--create:
  qvm.vm:
    - name: {{ dev.get('name', 'personal-dev') }}
    - present:
      - template: {{ dev.get('template', 'fedora-42-personal') }}
      - label: {{ dev.get('label', 'blue') }}
    - prefs:
      - label: {{ dev.get('label', 'blue') }}
      - netvm: {{ dev.get('netvm', 'sys-firewall') }}
      - memory: {{ dev.get('memory', 4096) }}
      - maxmem: {{ dev.get('maxmem', 8192) }}
      - vcpus: {{ dev.get('vcpus', 2) }}
    - features:
      - set:
        - menu-items: "{{ dev.get('menu_items', 'librewolf.desktop mullvad-browser.desktop codium.desktop org.gnome.Nautilus.desktop') }}"

{% set browsing = appvms.get('browsing', {}) %}
personal-browsing--create:
  qvm.vm:
    - name: {{ browsing.get('name', 'personal-browsing') }}
    - present:
      - template: {{ browsing.get('template', 'fedora-42-personal') }}
      - label: {{ browsing.get('label', 'blue') }}
    - prefs:
      - label: {{ browsing.get('label', 'green') }}
      - netvm: {{ browsing.get('netvm', 'sys-firewall') }}
      - memory: {{ browsing.get('memory', 4096) }}
      - maxmem: {{ browsing.get('maxmem', 6144) }}
      - vcpus: {{ browsing.get('vcpus', 2) }}
    - features:
      - set:
        - menu-items: "{{ browsing.get('menu_items', 'librewolf.desktop mullvad-browser.desktop org.gnome.Nautilus.desktop') }}"

{% endif %}