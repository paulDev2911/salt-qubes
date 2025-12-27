user:
  'fedora-42-personal':
    - personal.template
  
  'debian-13-vault':
    - vault.template
  
  'fedora-42-net':
    - sys-net.template
  
  'personal-vault':
    - split-gpg.server
  
  'personal-dev':
    - split-gpg.clients
  
  'dom0':
    - personal
    - vault
    - sys-net
    - policies
    - dom0
    - split-gpg