#!/bin/sh
sudo apt-get update -qq
sudo apt-get install -yqq curl socat time
.travis/ubuntu-compile-nsenter.sh
sudo cp .tmp/util-linux-2.30.2/nsenter /usr/bin/
