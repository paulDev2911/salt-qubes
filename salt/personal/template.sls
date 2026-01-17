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
{% if 'brave' in packages %}
{% set br = packages.brave %}
brave--ensure-dnf-plugins:
  pkg.installed:
    - name: dnf-plugins-core

brave--add-repo:
  cmd.run:
    - name: dnf config-manager addrepo --from-repofile={{ br.repo_url }}
    - env:
      - https_proxy: {{ proxy }}
    - creates: {{ br.repo_file }}
    - require:
      - pkg: brave--ensure-dnf-plugins

brave--install:
  pkg.installed:
    - name: {{ br.package }}
    - require:
      - cmd: brave--add-repo
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
{% if 'sops' in packages %}
{% set sp = packages.sops %}
sops--download:
  cmd.run:
    - name: curl -L -o /tmp/sops.rpm {{ sp.download_url }}
    - env:
      - https_proxy: {{ proxy }}
    - creates: /usr/local/bin/sops
    - unless: test -f /usr/local/bin/sops

sops--install:
  cmd.run:
    - name: rpm -i /tmp/sops.rpm
    - unless: rpm -q sops
    - require:
      - cmd: sops--download

sops--cleanup:
  file.absent:
    - name: /tmp/sops.rpm
    - require:
      - cmd: sops--install
{% endif %}
{% if 'age' in packages %}
{% set ag = packages.age %}
age--download:
  cmd.run:
    - name: curl -L -o /tmp/age.tar.gz {{ ag.download_url }}
    - env:
      - https_proxy: {{ proxy }}
    - creates: /usr/local/bin/age
    - unless: test -f /usr/local/bin/age

age--extract:
  archive.extracted:
    - name: /tmp/age-extract
    - source: /tmp/age.tar.gz
    - archive_format: tar
    - unless: test -f /usr/local/bin/age
    - require:
      - cmd: age--download

age--install:
  cmd.run:
    - name: |
        install -m 755 /tmp/age-extract/age/age /usr/local/bin/age
        install -m 755 /tmp/age-extract/age/age-keygen /usr/local/bin/age-keygen
    - unless: test -f /usr/local/bin/age
    - require:
      - archive: age--extract

age--cleanup:
  file.absent:
    - names:
      - /tmp/age.tar.gz
      - /tmp/age-extract
    - require:
      - cmd: age--install
{% endif %}
{% endif %}