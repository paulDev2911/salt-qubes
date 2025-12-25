appvms:
  personal:
    dev:
      name: personal-dev
      template: fedora-42-personal
      label: blue
      netvm: sys-firewall
      memory: 4096
      maxmem: 8192
      vcpus: 2
      menu_items: librewolf.desktop mullvad-browser.desktop codium.desktop org.gnome.Nautilus.desktop
      applications:
        - librewolf
        - mullvad-browser
        - codium
        
    browsing:
      name: personal-browsing
      template: fedora-42-personal
      label: blue
      netvm: sys-firewall
      memory: 4096
      maxmem: 6144
      vcpus: 2
      menu_items: librewolf.desktop mullvad-browser.desktop org.gnome.Nautilus.desktop
      applications:
        - librewolf
        - mullvad-browser