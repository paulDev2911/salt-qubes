sys-net:
  template:
    name: fedora-42-net
    source: fedora-42-minimal
    proxy: http://127.0.0.1:8082
    packages:
      - wireguard-tools
      - iproute
      - nftables
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - procps-ng
      - bind-utils
      - iputils
      - traceroute
      - curl
  
  mullvad:
    name: sys-mullvad
    template: fedora-42-net
    label: red
    netvm: sys-firewall
    provides_network: true
    memory: 400
    maxmem: 800
    vcpus: 1
    autostart: false
    
    wireguard:
      private_key: ""
      address: ""
      dns: ""
      
      peers:
        - public_key: ""
          endpoint: ""
          allowed_ips: ""
          persistent_keepalive: 25