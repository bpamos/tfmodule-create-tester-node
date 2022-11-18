---

- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  gather_facts: yes

  vars:
    deb_packages:
      - docker-compose

  pre_tasks:
    - name: Ubuntu Packages
      package:
        name: "{{ deb_packages }}"


  tasks:
    - name: load vars
      include_vars: default.yaml


# Prepare Node for Prometheus & Grafana
    - name: make prometheus directory
      file:
        path: /home/prometheus
        state: directory

    - name: copy prometheus yml
      copy:
        src: /tmp/${vpc_name}_prometheus.yml
        dest: /home/prometheus/${vpc_name}_prometheus.yml

    - name: copy docker compose yml
      copy:
        #src: /tmp/${vpc_name}_docker_compose.yml
        #dest: /home/${vpc_name}_docker_compose.yml
        src: /tmp/docker-compose.yml
        dest: /home/docker-compose.yml


    - name: docker-compose up
      command: docker-compose up -d
      args:
        chdir: /home/


# start the containers (docker-compose up -d)
# In browser go to:
# http://your-external-ip-address:9090
### manually configure Grafana.

