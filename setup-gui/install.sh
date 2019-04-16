#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

if [ -z ${SKIP_PYCHARM+x} ]; then
  echo 'Downloading Pycharm'
  wget --quiet --progress=bar:force https://download-cf.jetbrains.com/python/pycharm-community-2019.1.1.tar.gz -O /tmp/pycharm-community.tar.gz
  echo 'Installing Pycharm'
  mkdir -p /opt/pycharm
  cd /tmp && tar -xf /tmp/pycharm-community.tar.gz
  rm -r /tmp/pycharm-community.tar.gz
  mv pycharm-community-*/* /opt/pycharm
  rm /tmp/pycharm-* -r
  ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm
fi

# Here in common script, we don't install xfce stuff which could break laptop/physical host's setup
apt-get update
apt-get install -y --no-install-recommends \
  ristretto evince \
  gitk git-cola \
  gnupg-agent meld terminator  \
  dictionaries-common emacs emacs-goodies-el
