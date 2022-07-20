base:
  'k3d':
    - jupyter
    - docker
    - kubectl
    - k3d
    - helm
    - k8s_common.kmods
    - k8s_common.disable_swap

  'k8s*':
    - k8s_common
  'k8s-control':
    - jupyter