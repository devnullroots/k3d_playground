k8s_hosts_file:
  file.replace:
    - name: /etc/hosts
    - pattern: "focal"
    - repl: {{grains['id']}}
    - unless:
      - func: match.grain
      - tgt: "host:{{grains['id']}}"

k8s_hostnamectl:
  cmd.run:
    - name: hostnamectl set-hostname {{grains['id']}}
    - unless:
      - func: match.grain
      - tgt: "host:{{grains['id']}}"

k8s_hostname:
  cmd.run:
    - name: hostname {{grains['id']}}
    - unless:
      - func: match.grain
      - tgt: "host:{{grains['id']}}"

hostname_reload_grains:
  module.run:
    - saltutil.refresh_grains:
    - watch:
      - file: k8s_hosts_file
      - cmd: k8s_hostnamectl
      - cmd: k8s_hostname
    