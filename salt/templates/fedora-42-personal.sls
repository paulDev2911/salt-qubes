{% if grains['id'] == 'dom0' %}
create-fedora-42-personal-template:
  qvm.clone:
    - name: fedora-42-personal
    - source: fedora-42-xfce

{% elif grains['id'] == 'fedora-42-personal' %}

librewolf-repo--add-repository:
  cmd.run:
    - name: curl -fsSL https://repo.librewolf.net/librewolf.repo -o /etc/yum.repos.d/librewolf.repo
    - env:
      - https_proxy: http://127.0.0.1:8082
    - creates:
      - /etc/yum.repos.d/librewolf.repo

librewolf--install:
  pkg.installed:
    - name: librewolf
    - require:
      - cmd: librewolf-repo--add-repository

vscodium--import-gpg-key:
  cmd.run:
    - name: rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    - env:
      - https_proxy: http://127.0.0.1:8082
    - unless: rpm -q gpg-pubkey --qf '%{description}\n' | grep -q "vscodium"

vscodium-repo--add-repository:
  file.managed:
    - name: /etc/yum.repos.d/vscodium.repo
    - contents: |
        [gitlab.com_paulcarroty_vscodium_repo]
        name=download.vscodium.com
        baseurl=https://download.vscodium.com/rpms/
        enabled=1
        gpgcheck=1
        repo_gpgcheck=1
        gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
        metadata_expire=1h
    - require:
      - cmd: vscodium--import-gpg-key

vscodium--install:
  pkg.installed:
    - name: codium
    - require:
      - file: vscodium-repo--add-repository

mullvad-browser-repo--add-repository:
  cmd.run:
    - name: dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
    - env:
      - https_proxy: http://127.0.0.1:8082
    - creates:
      - /etc/yum.repos.d/mullvad.repo

mullvad-browser--install:
  pkg.installed:
    - name: mullvad-browser
    - require:
      - cmd: mullvad-browser-repo--add-repository

{% endif %}