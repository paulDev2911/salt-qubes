{% set cfg = pillar.get('vault', {}) %}
{% set tpl = cfg.get('template', {}) %}
{% set proxy = tpl.get('proxy', 'http://127.0.0.1:8082') %}

{% if grains['id'] == 'dom0' %}
vault-template--create:
  qvm.clone:
    - name: {{ tpl.get('name', 'debian-13-vault') }}
    - source: {{ tpl.get('source', 'debian-13-minimal') }}

{% elif grains['id'] == tpl.get('name', 'debian-13-vault') %}

vault--update-apt:
  cmd.run:
    - name: apt-get update
    - env:
      - https_proxy: {{ proxy }}
      - http_proxy: {{ proxy }}

vault--install-packages:
  pkg.installed:
    - pkgs:
      {% for pkg in tpl.get('packages', []) %}
      - {{ pkg }}
      {% endfor %}
    - require:
      - cmd: vault--update-apt

{% endif %}