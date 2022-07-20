k8shosts_append:
  file.append:
    - name: /etc/hosts
    - text:
      - "10.0.10.10 k8s-control"
      - "10.0.10.11 k8s-worker1"
      - "10.0.10.12 k8s-worker2"
    - require:
      - sls: k8s_common.hostname