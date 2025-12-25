{% set tpl = pillar.get('templates', {}).get('debian-13-vault', {}) %}
{% set proxy = tpl.get('proxy_url', 'http://127.0.0.1:8082') %}

{% if grains['id'] == 'dom0' %}
create-debian-13-vault-template:
  qvm.clone:
    - name: debian-13-vault
    - source: {{ tpl.get('source_template', 'debian-13-minimal') }}

{% elif grains['id'] == 'debian-13-vault' %}

vault--update-apt:
  cmd.run:
    - name: apt-get update
    - env:
      - https_proxy: {{ proxy }}
      - http_proxy: {{ proxy }}

vault--install-essentials:
  pkg.installed:
    - pkgs:
      - keepassxc
      - qubes-core-agent-passwordless-root
      - zenity
    - require:
      - cmd: vault--update-apt

{% endif %}