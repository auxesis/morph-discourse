#!/bin/bash

apt update
apt install -y python-setuptools build-essential python-dev
easy_install pip
pip install ansible
