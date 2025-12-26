vault:
  template:
    name: debian-13-vault
    source: debian-13-minimal
    proxy: http://127.0.0.1:8082
    packages:
      - keepassxc
      - qubes-core-agent-passwordless-root
      - zenity
  
  vm:
    name: personal-vault
    label: black
    netvm: ''
    memory: 400
    maxmem: 800
    vcpus: 1
    autostart: false
    menu_items: org.keepassxc.KeePassXC.desktop