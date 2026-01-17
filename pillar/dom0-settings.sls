dom0:
  global_prefs:
    clockvm: sys-mullvad
    updatevm: sys-whonix
    default_netvm: sys-mullvad
    default_dispvm: default-dvm
  
  updates:
    check_updates: true
    repos:
      - repo: qubes-dom0-current
        enabled: true
      - repo: qubes-dom0-current-testing
        enabled: false
      - repo: qubes-dom0-unstable
        enabled: false