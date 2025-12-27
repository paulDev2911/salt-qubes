{% set cfg = pillar.get('split_gpg', {}) %}
{% set servers = cfg.get('servers', {}) %}

# Build list of all clients across all servers
{% set all_clients = [] %}
{% for server_name, server_config in servers.items() %}
  {% for client in server_config.get('allowed_clients', []) %}
    {% do all_clients.append(client) %}
  {% endfor %}
{% endfor %}

{% set vm_name = grains['id'] %}

{% if vm_name == 'dom0' %}

# Enable split-gpg2-client service for each client
{% for client in all_clients %}
split-gpg-client--{{ client }}--service:
  qvm.service:
    - name: {{ client }}
    - enable:
      - split-gpg2-client
{% endfor %}

{% elif vm_name in all_clients %}

# Install split-gpg2 in client
split-gpg-client--install:
  pkg.installed:
    - pkgs:
      - split-gpg2
      - gnupg2

{% endif %}