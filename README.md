# ops-base

This repository provides a reference on which packages should be installed on CI agents and your workstation.
It can be used to bootstrap a development and operations environment.

The tools are needed to support scripting operations in bash and python using
 - releaser
 - secret-ops
 - docker-ops

After installing docker, this is also a sufficient environment to work with dojo.

## Specification

Correctly provisioned environment should have:
 * several basic linux CLI tools
 * useful networking tools
 * sane APT setup
 * sudo, but no configuration is provided here
 * all kinds of compression and decompression tools
 * git
 * python 3.5 setup (unless `SKIP_PYTHON_BASE` is set)
 * several python tools listed in `setup/requirements.txt` (unless `SKIP_PYTHON_TOOLS` is set)
 * hashicorp vault (unless `SKIP_VAULT` is set)
 * docker-compose which is a basis for `dojo`
 * `jq`
 * `bats`
 * dojo - to make this environment capable of working with any project
 * docker. However by default docker is not installed, because docker configuration is platform specific. To install it quickly set `INSTALL_DOCKER`.

Additional steps for anything above this:
 * install and configure docker
 * still have to setup a non-root user with docker access

## Usage

Installing in docker image:
```
git clone http://git.ai-traders.com/platform/python-ops.git /tmp/ops-base &&\
 cd /tmp/ops-base/setup &&\
 ./install.sh
```

The `setup/install.sh` is intended to be run on both workstation and CI agent images.
`install_pycharm.sh` should be executed only in workstation image.

Options:
 * `SKIP_VAULT` - for those that don't use hashicorp vault
 * `SKIP_PYTHON_BASE` - will not try to install python with apt-get or alike
 * `SKIP_PYTHON_TOOLS` - will not install tools from `setup/requirements.txt`

By default docker is not installed, because docker configuration is platform specific. To install it quickly set `INSTALL_DOCKER`.
