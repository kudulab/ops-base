FROM ubuntu:16.04

COPY ./ /ops

RUN cd /ops && ./install.sh
RUN cd /ops && ./install_pycharm.sh
