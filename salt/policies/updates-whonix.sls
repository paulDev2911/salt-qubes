{% set cfg = pillar.get('policies', {}) %}
{% set updates = cfg.get('updates_via_whonix', {}) %}

{% if grains['id'] == 'dom0' %}

# RPC Policy for template updates
updates-whonix--policy:
  file.managed:
    - name: /etc/qubes/policy.d/30-updates-whonix.policy
    - source: salt://policies/files/30-updates-whonix.policy.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        gateway: {{ updates.get('gateway', 'sys-whonix') }}
        excluded_templates: {{ updates.get('excluded_templates', []) }}

# Set dom0 updatevm
{% if updates.get('dom0_via_whonix', True) %}
updates-whonix--dom0-updatevm:
  cmd.run:
    - name: qubes-prefs updatevm {{ updates.get('gateway', 'sys-whonix') }}
    - unless: test "$(qubes-prefs updatevm)" = "{{ updates.get('gateway', 'sys-whonix') }}"
{% else %}
updates-whonix--dom0-updatevm-default:
  cmd.run:
    - name: qubes-prefs updatevm sys-firewall
    - unless: test "$(qubes-prefs updatevm)" = "sys-firewall"
{% endif %}

{% endif %}