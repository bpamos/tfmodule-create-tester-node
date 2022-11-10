---

- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  gather_facts: yes

  vars:
    deb_packages:
      - default-jre
      - openjdk-11-jre-headless
      - openjdk-8-jre-headless
      - unzip

  pre_tasks:
    - name: Ubuntu Packages
      package:
        name: "{{ deb_packages }}"

  tasks:
    - name: load vars
      include_vars: default.yaml


# download RIOT (update the zip to ask user to look for most recent)
    - name: Download riot redis zip
      command: wget https://github.com/redis-developer/riot/releases/download/v${riot_version}/riot-redis-${riot_version}.zip
    - name: Unzip riot redis
      command: sudo unzip riot-redis-${riot_version}.zip