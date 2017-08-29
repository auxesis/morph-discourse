#!/bin/bash

apt update
apt install -y python-setuptools build-essential python-dev
easy_install pip

# Try to fix OpenSSL
rm -rf /usr/lib/python2.7/dist-packages/OpenSSL
rm -rf /usr/lib/python2.7/dist-packages/pyOpenSSL-0.15.1.egg-info
pip install pyopenssl

# Then install Ansible
pip install ansible
