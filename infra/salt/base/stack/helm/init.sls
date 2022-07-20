helm_reqs:
  pkg.installed:
    - pkgs:
      - apt-transport-https

helm_repo:
  pkgrepo.managed:
    - name: deb https://baltocdn.com/helm/stable/debian/ all main
    - file: /etc/apt/sources.list.d/helm-deb.list
    - key_url: https://baltocdn.com/helm/signing.asc
    - require:
      - pkg: helm_reqs

helm:
  pkg.installed:
    - name: helm
    - version: 3.9.1-1
    - require:
      - pkgrepo: helm_repo