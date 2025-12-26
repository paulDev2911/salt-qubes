{% set cfg = pillar.get('sys-net', {}) %}
{% set tpl = cfg.get('template', {}) %}
{% set proxy = tpl.get('proxy', 'http://127.0.0.1:8082') %}

{% if grains['id'] == 'dom0' %}
net-template--create:
  qvm.clone:
    - name: {{ tpl.get('name', 'fedora-42-net') }}
    - source: {{ tpl.get('source', 'fedora-42-minimal') }}

net-template--set-netvm:
  qvm.prefs:
    - name: {{ tpl.get('name', 'fedora-42-net') }}
    - netvm: sys-firewall
    - require:
      - qvm: net-template--create

{% elif grains['id'] == tpl.get('name', 'fedora-42-net') %}

# Install all required packages for VPN/networking
net-template--install-packages:
  pkg.installed:
    - pkgs:
      {% for pkg in tpl.get('packages', []) %}
      - {{ pkg }}
      {% endfor %}
    - refresh: True

{% endif %}