kubectl_reqs:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl

kubectl_repo:
  pkgrepo.managed:
    - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
    - file: /etc/apt/sources.list.d/kubectl.list
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
    - require:
      - pkg: kubectl_reqs

kubectl:
  pkg.installed:
    - name: kubectl
    - version: 1.24.3-00
    - require:
      - pkgrepo: kubectl_repo