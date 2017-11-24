#!/bin/sh
TMP_DIR=$(mktemp -d --suffix='.reactionetes')

echo Reactionetes
cd $TMP_DIR
git clone https://github.com/joshuacox/reactionetes.git
cd reactionetes
make autopilot

cd
rm -Rf $TMP_DIR
