{% set dom0 = pillar.get('dom0', {}) %}
{% set prefs = dom0.get('global_prefs', {}) %}
{% set updates = dom0.get('updates', {}) %}

{% if grains['id'] == 'dom0' %}

# Global preferences
{% for pref, value in prefs.items() %}
dom0-pref-{{ pref }}:
  cmd.run:
    - name: qubes-prefs {{ pref }} {{ value }}
    - unless: test "$(qubes-prefs {{ pref }})" = "{{ value }}"
{% endfor %}

# Repository configuration
{% for repo_config in updates.get('repos', []) %}
dom0-repo-{{ repo_config.repo }}:
  file.managed:
    - name: /etc/yum.repos.d/{{ repo_config.repo }}.repo
    - replace: false
    - makedirs: true

dom0-repo-{{ repo_config.repo }}--enabled:
  ini.options_present:
    - name: /etc/yum.repos.d/{{ repo_config.repo }}.repo
    - sections:
        {{ repo_config.repo }}:
          enabled: {{ '1' if repo_config.enabled else '0' }}
    - require:
      - file: dom0-repo-{{ repo_config.repo }}
{% endfor %}

{% endif %}