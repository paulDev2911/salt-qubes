{% set cfg = pillar.get('split_gpg', {}) %}
{% set servers = cfg.get('servers', {}) %}
{% set vm_name = grains['id'] %}

{% if vm_name in servers.keys() %}

# Install split-gpg2 in server
split-gpg-server--install:
  pkg.installed:
    - pkgs:
      - split-gpg2
      - gnupg2

{% endif %}