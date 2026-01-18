personal:
  template:
    name: fedora-42-personal
    source: fedora-42-xfce
    proxy: http://127.0.0.1:8082
    
    packages:
      brave:
        repo_url: https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        repo_file: /etc/yum.repos.d/brave-browser.repo
        package: brave-browser      
      
      mullvad:
        repo_url: https://repository.mullvad.net/rpm/stable/mullvad.repo
        repo_file: /etc/yum.repos.d/mullvad.repo
        package: mullvad-browser
      
      vscodium:
        gpg_key_url: https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
        repo_file: /etc/yum.repos.d/vscodium.repo
        package: codium
        repo_config:
          name: download.vscodium.com
          baseurl: https://download.vscodium.com/rpms/
          enabled: 1
          gpgcheck: 1
          repo_gpgcheck: 1
          metadata_expire: 1h
      
      sops:
        download_url: https://github.com/getsops/sops/releases/download/v3.9.2/sops-3.9.2-1.x86_64.rpm
      
      age:
        download_url: https://github.com/FiloSottile/age/releases/download/v1.2.0/age-v1.2.0-linux-amd64.tar.gz

      packer:
        download_url: https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_linux_amd64.zip
      
      terraform:
        repo_url: https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        repo_file: /etc/yum.repos.d/hashicorp.repo
        package: terraform
  
  vms:
    dev:
      name: personal-dev
      label: blue
      netvm: sys-firewall
      memory: 4096
      maxmem: 8192
      vcpus: 2
      menu_items: brave-browser.desktop mullvad-browser.desktop codium.desktop Thunar.desktop xfce4-terminal.desktop
    
    browsing:
      name: personal-browsing
      label: blue
      netvm: sys-firewall
      memory: 4096
      maxmem: 6144
      vcpus: 2
      menu_items: brave-browser.desktop mullvad-browser.desktop Thunar.desktop xfce4-terminal.desktop