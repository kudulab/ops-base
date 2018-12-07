#!/bin/bash -e

apt-get update

export DEBIAN_FRONTEND=noninteractive

apt-get install -y --no-install-recommends\
  wget curl ca-certificates nano tar zip unzip bzip2 rsync ssh-client\
  python3.5 python3-pip tox &&\
  apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean &&\
  rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

pip3 install -r requirements.txt
