## ansible arch
control node - where ansible runs
managed nodes - target servers 
inventory - list of hosts
modules - units of work(reusable scripts that performs task)
playbooks - auto logic

key: value
list:
    - item1
    - item2

Idempotency = same result withour changes

handlers = used for restart/reload only when chage occurs
notify: restart nginx

register & debug
- shell: uptime
  register: output

- debug:
  var: output.stdout

ansible-vault encrypt secrets.yml

role dir structure
roles/
    web/
        tasks/
            handlers/
                vars/
                    templates/


# loops
with_items:
  - git
  - nginx

## conditionals
when: ansible_os_family == "Debian"

# templates(jinja2 )
listen {{ port }};

## facts = sys info colllected auto
ansible_facts['os_famiily']

gather_facts: false # disable facts

# tags
ansible-playbook site.yml --tags nginx

Changed = 0

become: yes
--ask-become-pass

serial: 2

## rolling restart
serial: 1

