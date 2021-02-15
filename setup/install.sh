#!/bin/bash

set -e

VAULT_VERSION="1.1.1"
DOCKER_COMPOSE_VERSION="1.23.2"
DOJO_VERSION="0.10.3"

SETUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SETUP_DIR

WGET="wget --tries=3 --retry-connrefused --wait=3 --random-wait --quiet --show-progress --progress=bar:force"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  brew install wget gnupg2
else
  # Linux
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  # minimal tools
  apt-get install -y --no-install-recommends\
    apt-transport-https \
    sudo bash-completion \
    software-properties-common lsb-release \
    tar zip unzip bzip2 \
    git wget curl rsync ssh-client ca-certificates \
    nano \
    gnupg2 \
    net-tools iperf tcpdump tcptrace iputils-ping
fi

if [ -z ${SKIP_PYTHON_BASE+x} ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    brew install python3
  else
    apt-get install -y --no-install-recommends\
      python3.5 python3-pip tox
  fi
fi

if [ -z ${SKIP_PYTHON_TOOLS+x} ]; then
  pip3 install -r requirements.txt
fi

if [ -z ${SKIP_VAULT+x} ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    VAULT_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_darwin_amd64.zip"
  else
    VAULT_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"
  fi
  cd /tmp &&\
    $WGET -O /tmp/vault.zip $VAULT_URL &&\
    unzip /tmp/vault.zip &&\
    cp /tmp/vault /usr/local/bin/vault &&\
    chmod +x /usr/local/bin/vault &&\
    rm -rf /tmp/vault*
  cd $SETUP_DIR
fi

if [[ "$OSTYPE" != "darwin"* ]]; then
  # docker-compose is part of Docker for Desktop package
  $WGET -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`
  chmod +x /usr/local/bin/docker-compose
fi

# install jq
JQ_VERSION=1.6
if [[ "$OSTYPE" == "darwin"* ]]; then
  JQ_URL=https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-osx-amd64
else
  JQ_URL=https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64
fi
$WGET -O jq $JQ_URL
chmod +x ./jq
mv -f ./jq /usr/local/bin/jq

# Install Dojo
if [[ "$OSTYPE" == "darwin"* ]]; then
  wget -O /usr/local/bin/dojo https://github.com/kudulab/dojo/releases/download/${DOJO_VERSION}/dojo_darwin_amd64
  chmod +x /usr/local/bin/dojo
else
  wget -O /usr/bin/dojo https://github.com/ai-traders/dojo/releases/download/${DOJO_VERSION}/dojo_linux_amd64
  chmod +x /usr/bin/dojo
fi

# Install
git clone --depth 1 https://github.com/sstephenson/bats.git /tmp/bats &&\
  git clone --depth 1 https://github.com/ztombol/bats-support.git /opt/bats-support &&\
  git clone --depth 1 https://github.com/ztombol/bats-assert.git /opt/bats-assert &&\
  /tmp/bats/install.sh /usr/local

if [[ "$OSTYPE" != "darwin"* ]]; then
  if [ -n "${INSTALL_AIT_CA}" ]; then
    cp $SETUP_DIR/ait.crt /usr/local/share/ca-certificates/ait.crt
    update-ca-certificates
  fi

  if [ -n "${INSTALL_DOCKER}" ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
  fi

  # helpful script to wait for docker socket
  cp $SETUP_DIR/docker-wait /usr/bin/docker-wait

  apt-get -y autoremove
  apt-get -y autoclean
  apt-get -y clean
  rm -rf /var/tmp/*
  rm -rf /var/lib/apt/lists/*
fi
