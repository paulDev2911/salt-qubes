{% set cfg = pillar.get('split_gpg', {}) %}
{% set servers = cfg.get('servers', {}) %}

{% if grains['id'] == 'dom0' %}

split-gpg--policy:
  file.managed:
    - name: /etc/qubes/policy.d/30-user-gpg2.policy
    - user: root
    - group: root
    - mode: 644
    - contents: |
        ## Split-GPG2 Policy
        ## Managed by Salt - DO NOT EDIT MANUALLY
        
        {% for server_name, server_config in servers.items() %}
        # Server: {{ server_name }}
        {% for client in server_config.get('allowed_clients', []) %}
        qubes.Gpg2 + {{ client }} @default allow target={{ server_name }}
        {% endfor %}
        
        {% endfor %}
        # Deny all other GPG2 requests
        qubes.Gpg2 * @anyvm @anyvm deny

{% endif %}