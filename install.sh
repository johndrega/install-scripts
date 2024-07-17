#! /bin/bash

if [ -z "$(which python3)" ]; then
    echo "Python3 is not installed. Please install it before running this script."
    exit 1
fi

if [ -z "$(which pip)" ]; then
    echo "Python's package manager is not installed. Please install it before running this script."
    exit 1
fi

if [ -z "$(which ansible)" ]; then
    echo "Ansible is not installed. Please install it before running this script."
    exit 1
fi

ansible-playbook -u $(whoami) install.ansible.yml --ask-become-pass