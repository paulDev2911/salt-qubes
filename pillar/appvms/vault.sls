appvms:
  vault:
    name: personal-vault
    template: debian-13-vault
    label: black
    netvm: ''
    memory: 400
    maxmem: 800
    vcpus: 1
    autostart: false
    menu_items: org.keepassxc.KeePassXC.desktop