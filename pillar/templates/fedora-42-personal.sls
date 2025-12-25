templates:
  fedora-42-personal:
    source_template: fedora-42-xfce
    proxy_url: http://127.0.0.1:8082
    
    browsers:
      librewolf:
        repo_url: https://repo.librewolf.net/librewolf.repo
        repo_file: /etc/yum.repos.d/librewolf.repo
        package: librewolf
        
      mullvad:
        repo_url: https://repository.mullvad.net/rpm/stable/mullvad.repo
        repo_file: /etc/yum.repos.d/mullvad.repo
        package: mullvad-browser
    
    editors:
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