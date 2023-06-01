# Configure development environment

If you're using Ubuntu you might want to remove the `unattended-upgrades` packages since it can annoyingly
take dpkg lock and prevent you from installing packages: `sudo apt remove unattended-upgrades`

Run with: `ansible-playbook -u your_username --connection=local -i "localhost," --ask-become-pass playbook.ansible.yml`
