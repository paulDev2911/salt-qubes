{%- set mullvad = pillar.get('vpn', {}).get('mullvad', {}) %}
{%- set proxy = mullvad.get('proxy_url', 'http://127.0.0.1:8082') %}
{%- set template_name = mullvad.get('template_name', 'debian-13-mullvad') %}
{%- set vm_name = mullvad.get('vm_name', 'sys-mullvad') %}
{%- set wg_interface = 'mullvad-' ~ mullvad.get('server_location', 'sacred-boa') %}

{% if grains['id'] == 'dom0' %}

create-{{ template_name }}-template:
  qvm.clone:
    - name: {{ template_name }}
    - source: {{ mullvad.get('source_template', 'debian-13-xfce') }}

create-{{ vm_name }}:
  qvm.vm:
    - name: {{ vm_name }}
    - present:
      - template: {{ template_name }}
      - label: {{ mullvad.get('label', 'purple') }}
    - prefs:
      - netvm: {{ mullvad.get('netvm', 'sys-firewall') }}
      - provides_network: True
      - memory: {{ mullvad.get('memory', 400) }}
      - autostart: {{ mullvad.get('autostart', True) }}
    - require:
      - qvm: create-{{ template_name }}-template

{% elif grains['id'] == template_name %}

{{ template_name }}--update-apt:
  cmd.run:
    - name: apt-get update
    - env:
      - https_proxy: {{ proxy }}
      - http_proxy: {{ proxy }}

{{ template_name }}--install-packages:
  pkg.installed:
    - pkgs:
      {%- for pkg in mullvad.get('packages', []) %}
      - {{ pkg }}
      {%- endfor %}
    - require:
      - cmd: {{ template_name }}--update-apt

{% elif grains['id'] == vm_name %}

{{ vm_name }}--wg-config:
  file.managed:
    - name: /rw/config/wireguard/{{ wg_interface }}.conf
    - source: salt://vpn/templates/wireguard.conf.j2
    - template: jinja
    - makedirs: True
    - mode: 600
    - context:
        wg_config: {{ mullvad.wg_config }}

{{ vm_name }}--rc-local:
  file.managed:
    - name: /rw/config/rc.local
    - mode: 755
    - contents: |
        #!/bin/bash
        wg-quick up {{ wg_interface }}

{% endif %}