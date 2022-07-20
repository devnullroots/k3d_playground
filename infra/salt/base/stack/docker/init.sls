docker_reqs:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg
      - lsb-release

docker_repo:
  pkgrepo.managed:
    - name: "deb https://download.docker.com/linux/ubuntu {{grains['oscodename']}} stable"
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - file: /etc/apt/sources.list.d/docker.list
    - require:
      - pkg: docker_reqs

docker_bundle:
  pkg.installed:
    - pkgs:
      - docker-ce: 5:20.10.17~3-0~ubuntu-focal
      - docker-ce-cli: 5:20.10.17~3-0~ubuntu-focal
      - containerd.io: 1.6.6-1
      - docker-compose-plugin: 2.6.0~ubuntu-focal
    - require:
      - pkgrepo: docker_repo
      - pkg: docker_reqs