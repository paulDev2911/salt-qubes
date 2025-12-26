{% set cfg = pillar.get('policies', {}) %}
{% set clipboard = cfg.get('clipboard_vault', {}) %}

{% if grains['id'] == 'dom0' %}

clipboard-vault--policy:
  file.managed:
    - name: /etc/qubes/policy.d/30-clipboard-vault.policy
    - user: root
    - group: root
    - mode: 644
    - contents: |
        ## Clipboard Policy: Vault Protection
        ## Managed by Salt - DO NOT EDIT MANUALLY
        
        # DENY: Nothing can be pasted INTO vault qubes
        {% for vault in clipboard.get('vault_qubes', []) %}
        qubes.ClipboardPaste * @anyvm {{ vault }} deny
        {% endfor %}
        
        # ALLOW: Vault can paste to specific personal qubes only
        {% for vault in clipboard.get('vault_qubes', []) %}
        {% for target in clipboard.get('vault_paste_targets', {}).get(vault, []) %}
        qubes.ClipboardPaste * {{ vault }} {{ target }} allow
        {% endfor %}
        {% endfor %}
        
        # DEFAULT: Allow everything else (standard Qubes behavior)
        qubes.ClipboardPaste * @anyvm @anyvm ask

{% endif %}