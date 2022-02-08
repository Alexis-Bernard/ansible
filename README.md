# Ansible

[Cours](https://github.com/pushou/pushou_public_pdf/blob/main/ansible-workshop.pdf) - [Links](https://registry.iutbeziers.fr:11443/pouchou/tp3automatisation)

## Init

```bash
./revert2cgroupv1.sh
./install_ansible.sh
./create-cont.sh
```

## Commands

List all containers
```bash
docker ps -a
```

Kill all containers
```bash
docker rm -f $(docker ps -a -q)
```

## Exercise

### 4.1

1. 
```bash
ansible all -m ping
```

2. 
```bash
ansible all -a "ip a"
```

3. 
The used protocol is SSH

4. 
`Ansible -vvv` enable verbose mode. Ansible is agentless because only python and ssh are needed on workers.

5. 
```bash
ansible -m setup -a 'filter=*addr*' debian
```

6. 
“Ungrouped” is the default group.


### 4.2

1. 
```bash
ansible -m dnf -a "name=httpd state=latest" rocky-0
ansible -m apt -a "name=apache2 state=latest" debian-0
```

3. 
```bash
ansible-playbook --check apache2-lamp-debian.yml
ansible-playbook --diff apache2-lamp-debian.yml
ansible-playbook apache2-lamp-debian.yml
```

4. 
```yaml
---
- hosts: rocky
 tasks:
   - name: Installer Httpd
     ansible.builtin.dnf:
       name=httpd state=present update_cache=true

   - name: Installer Php7
     ansible.builtin.dnf:
       name=php state=present

   - name: Démarrer le service Httpd
     ansible.builtin.service:
       name=httpd state=started enabled=true

   - name: copier un phpinfo
     ansible.builtin.copy:
       src=info.php dest=/var/www/html/index.php owner=apache group=apache mode=0664
```
5. 
```bash
ansible -m setup -a debian
```
*The facts are all information about computers at runtime.*
6. 
```bash
ansible -m setup -a 'filter=*addr*' debian
```
7. 
To run : `ansible-playbook apache2-lamp-debian.yml --tags reload`
```bash
- name: reload
 ansible.builtin.service:
   name=apache2 state=reloaded enabled=true
 tags:
 - reload
```
8. 
Never : Disable a task
Always : This tag ensures that this task will always be executed
9. 
```bash
   - name: Template configuration file
     ansible.builtin.template:
       src: ports.j2
       dest: /etc/apache2/ports.conf
     notify:
       - Restart apache
      
 handlers:
   - name: Restart apache
     ansible.builtin.service:
       name: apache2
       state: restarted
```

### 5.0 


```yaml
   - name: Installer Apache & Php7
     ansible.builtin.apt: name=apache2 state=present update_cache=true
     loop:
     - apache2
     - libapache2-mod-php7.4

.
when: ansible_facts['os_family'] == 'Debian'
```

