include:
  - k8s_common.kmods

containerd:
  pkg.installed:
    - name: containerd
    - require:
      - sls: k8s_common.kmods
containerd_etc_dir:
  file.directory:
    - name: /etc/containerd
    - owner: root
    - group: root

containerd_config:
  file.managed:
    - source: salt://k8s_common/templates/config.toml
    - name: /etc/containerd/config.toml
    - require: 
      - file: containerd_etc_dir
      - pkg: containerd

containerd_service:
  service.running:
    - enable: True
    - name: containerd
    - watch:
      - file: containerd_config
      - pkg: containerd