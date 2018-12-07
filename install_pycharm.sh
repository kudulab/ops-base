#!/bin/bash

echo 'Downloading Pycharm'
wget --quiet --progress=bar:force --no-check-certificate http://os2.ai-traders.com:6780/swift/v1/pycharm/pycharm-community-2018.3.1.tar.gz -O /tmp/pycharm-community.tar.gz
echo 'Installing Pycharm'
mkdir -p /opt/pycharm
cd /tmp && tar -xf /tmp/pycharm-community.tar.gz
rm -r /tmp/pycharm-community.tar.gz
mv pycharm-community-*/* /opt/pycharm
rm /tmp/pycharm-* -r
ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm
