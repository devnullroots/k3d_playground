k3d:
  file.managed:
    - name: /usr/bin/k3d
    - source: https://github.com/k3d-io/k3d/releases/download/v5.4.4/k3d-linux-amd64
    - source_hash: 6b66a0d99b1dbe72da44959842664208552a8c6fee339e64b393f30f27e62e31b5fa181ce1d5b10e3b59ef6ea27cea2be6694f49646208da8773df24f199b62f
    - mode: 755