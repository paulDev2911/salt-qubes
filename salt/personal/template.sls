{% set cfg = pillar.get('personal', {}) %}
{% set tpl = cfg.get('template', {}) %}
{% set proxy = tpl.get('proxy', 'http://127.0.0.1:8082') %}

{% if grains['id'] == 'dom0' %}
personal-template--create:
  qvm.clone:
    - name: {{ tpl.get('name', 'fedora-42-personal') }}
    - source: {{ tpl.get('source', 'fedora-42-xfce') }}

{% elif grains['id'] == tpl.get('name', 'fedora-42-personal') %}

{% set packages = tpl.get('packages', {}) %}

{% if 'librewolf' in packages %}
{% set lw = packages.librewolf %}
librewolf--add-repo:
  cmd.run:
    - name: curl -fsSL {{ lw.repo_url }} -o {{ lw.repo_file }}
    - env:
      - https_proxy: {{ proxy }}
    - creates: {{ lw.repo_file }}

librewolf--install:
  pkg.installed:
    - name: {{ lw.package }}
    - require:
      - cmd: librewolf--add-repo
{% endif %}

{% if 'mullvad' in packages %}
{% set mb = packages.mullvad %}
mullvad--add-repo:
  cmd.run:
    - name: dnf config-manager addrepo --from-repofile={{ mb.repo_url }}
    - env:
      - https_proxy: {{ proxy }}
    - creates: {{ mb.repo_file }}

mullvad--install:
  pkg.installed:
    - name: {{ mb.package }}
    - require:
      - cmd: mullvad--add-repo
{% endif %}

{% if 'vscodium' in packages %}
{% set vs = packages.vscodium %}
vscodium--import-key:
  cmd.run:
    - name: rpmkeys --import {{ vs.gpg_key_url }}
    - env:
      - https_proxy: {{ proxy }}
    - unless: rpm -q gpg-pubkey --qf '%{description}\n' | grep -q "vscodium"

vscodium--add-repo:
  file.managed:
    - name: {{ vs.repo_file }}
    - contents: |
        [gitlab.com_paulcarroty_vscodium_repo]
        name={{ vs.repo_config.name }}
        baseurl={{ vs.repo_config.baseurl }}
        enabled={{ vs.repo_config.enabled }}
        gpgcheck={{ vs.repo_config.gpgcheck }}
        repo_gpgcheck={{ vs.repo_config.repo_gpgcheck }}
        gpgkey={{ vs.gpg_key_url }}
        metadata_expire={{ vs.repo_config.metadata_expire }}
    - require:
      - cmd: vscodium--import-key

vscodium--install:
  pkg.installed:
    - name: {{ vs.package }}
    - require:
      - file: vscodium--add-repo
{% endif %}

{% endif %}