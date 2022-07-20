#Checking if there are swaps through /proc/swaps and disable it
{% if salt['cmd.run']("/bin/bash -c 'wc -l < /proc/swaps'")|int > 1 %}
disable_swap:
  cmd.run:
    - name: "swapoff -a"
{%endif%}
disable_swap_fstab:
  file.line:
    - name: /etc/fstab
    - match: /swap
    - mode: delete