include: 
  - pre_reqs

#Create the folder to serve jupyter 
jupyter_folder:
  file.directory:
    - name: /srv/jupyter
    - user: root
    - group: root
    - dir_mode: 700

#Create the virtualenv for jypiter
jupyter_venv:
  virtualenv.managed:
    - user: root
    - name: /srv/jupyter/venv
    - requirements: salt://jupyter/requirements.txt
    - python: /usr/bin/python3
    - require:
      - sls: pre_reqs
      - file: jupyter_folder

#Calculate and/or fetch the password according to if the VM is a local vagrant
#VM (More convinient but insecure)
{% if grains['vplatform']=='vagrant'%}
{% set salted_pass= "vagrant"+"mysupersalt"%}
{% else %}
{% set salted_pass=grains["k3d_password"] + "mysupersalt"%}
{% endif %}
{%set hashed_pass = salt['hashutil.digest'](salted_pass,checksum='sha256')%}
jupyter_config:
  file.managed:
    - source: salt://jupyter/files/jupyter_notebook_config.j2
    - name: /srv/jupyter/config.py
    - template: jinja
    - context:
      notebook_password: "sha256:mysupersalt:{{hashed_pass}}"
      notebook_token: 'vagrant'
      notebook_dir: "/srv/jupyter/notebooks"
      notebook_remote_allow: "True"
      notebook_ip: '*'
    - require:
      - virtualenv: jupyter_venv

jupyter_service_file:
  file.managed:
    - source: salt://jupyter/files/jupyter.service.j2
    - name: /etc/systemd/system/jupyter.service
    - require:
      - file: jupyter_config

jupyter_service_enable:
  service.running:
    - name: jupyter
    - enable: true
    - watch:
      - file: jupyter_config


