k8s_control_reqs:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - curl

k8s_repo:
  pkgrepo.managed:
    - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
    - file: /etc/apt/sources.list.d/k8s.list
    - require: 
      - pkg: k8s_control_reqs 

k8s_bundle:
  pkg.installed:
    - pkgs:
      - kubelet: 1.23.0-00
      - kubeadm: 1.23.0-00
      - kubectl: 1.23.0-00
    - require:
      - pkgrepo: k8s_repo