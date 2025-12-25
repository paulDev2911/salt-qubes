{% set tpl = pillar.get('templates', {}).get('fedora-42-personal', {}) %}
{% set proxy = tpl.get('proxy_url', 'http://127.0.0.1:8082') %}

{% if grains['id'] == 'dom0' %}
create-fedora-42-personal-template:
  qvm.clone:
    - name: fedora-42-personal
    - source: {{ tpl.get('source_template', 'fedora-42-xfce') }}

{% elif grains['id'] == 'fedora-42-personal' %}

{% set lw = tpl.get('browsers', {}).get('librewolf', {}) %}
librewolf-repo--add-repository:
  cmd.run:
    - name: curl -fsSL {{ lw.get('repo_url') }} -o {{ lw.get('repo_file') }}
    - env:
      - https_proxy: {{ proxy }}
    - creates:
      - {{ lw.get('repo_file') }}

librewolf--install:
  pkg.installed:
    - name: {{ lw.get('package') }}
    - require:
      - cmd: librewolf-repo--add-repository

{% set vs = tpl.get('editors', {}).get('vscodium', {}) %}
vscodium--import-gpg-key:
  cmd.run:
    - name: rpmkeys --import {{ vs.get('gpg_key_url') }}
    - env:
      - https_proxy: {{ proxy }}
    - unless: rpm -q gpg-pubkey --qf '%{description}\n' | grep -q "vscodium"

vscodium-repo--add-repository:
  file.managed:
    - name: {{ vs.get('repo_file') }}
    - contents: |
        [gitlab.com_paulcarroty_vscodium_repo]
        name={{ vs.repo_config.name }}
        baseurl={{ vs.repo_config.baseurl }}
        enabled={{ vs.repo_config.enabled }}
        gpgcheck={{ vs.repo_config.gpgcheck }}
        repo_gpgcheck={{ vs.repo_config.repo_gpgcheck }}
        gpgkey={{ vs.get('gpg_key_url') }}
        metadata_expire={{ vs.repo_config.metadata_expire }}
    - require:
      - cmd: vscodium--import-gpg-key

vscodium--install:
  pkg.installed:
    - name: {{ vs.get('package') }}
    - require:
      - file: vscodium-repo--add-repository

{% set mb = tpl.get('browsers', {}).get('mullvad', {}) %}
mullvad-browser-repo--add-repository:
  cmd.run:
    - name: dnf config-manager addrepo --from-repofile={{ mb.get('repo_url') }}
    - env:
      - https_proxy: {{ proxy }}
    - creates:
      - {{ mb.get('repo_file') }}

mullvad-browser--install:
  pkg.installed:
    - name: {{ mb.get('package') }}
    - require:
      - cmd: mullvad-browser-repo--add-repository

{% endif %}