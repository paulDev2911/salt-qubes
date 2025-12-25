{% set base_template = salt['pillar.get']('templates:test.base_template') %}
{% set new_template = salt['pillar.get']('templates:test.new_template') %}
{% set packages = salt['pillar.get']('templates:test.packages') %}

{% if grains['id'] == 'dom0' %}

create-testtmp:
  qvm.clone:
    - name: {{ new_template }}
    - source: {{ base_template }}

{% elif grains['id'] == new_template %}

install_packages:
  pkg.installed:
    - name: {{ packages }}
    - target: {{ new_template }}

{% endif %}