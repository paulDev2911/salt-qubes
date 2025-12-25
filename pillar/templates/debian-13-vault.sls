templates:
  debian-13-vault:
    source_template: debian-13-minimal
    proxy_url: http://127.0.0.1:8082
    
    packages:
      keepass: keepassxc
      gui: qubes-core-agent-passwordless-root
    
    vault_config:
      enable_browser_integration: false
      enable_ssh_agent: false
      minimize_on_startup: true