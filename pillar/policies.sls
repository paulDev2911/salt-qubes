policies:
  updates_via_whonix:
    gateway: sys-whonix
    dom0_via_whonix: true
    excluded_templates:
      - whonix-gateway-17
      - whonix-workstation-17
  
  clipboard_vault:
    vault_qubes:
      - personal-vault
    
    vault_paste_targets:
      personal-vault:
        - personal-browsing
