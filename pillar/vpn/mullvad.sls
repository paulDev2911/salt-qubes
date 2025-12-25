vpn:
  mullvad:
    template_name: debian-13-mullvad
    source_template: debian-13-xfce
    proxy_url: http://127.0.0.1:8082
    
    packages:
      - wireguard-tools
      - qubes-core-agent-networking
    
    vm_name: sys-mullvad
    label: purple
    netvm: sys-firewall
    memory: 400
    maxmem: 400
    vcpus: 1
    autostart: true
    
    server_location: sacred-boa
    
