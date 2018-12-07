# python-ops

This repository provides a reference on which packages should be installed on CI agents and primary workstation,
in order to support scripting operations in python.

## Install

The `install.sh` is intended to be run on both workstation and go-agent images.
`install_pycharm.sh` should be executed only in workstation image.

Installing in docker image:
```
git clone http://git.ai-traders.com/platform/python-ops.git /tmp/python-ops &&\
 cd /tmp/python-ops &&\
 ./install.sh
```
