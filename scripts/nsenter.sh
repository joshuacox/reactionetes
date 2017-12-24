#!/usr/bin/dash
: ${R8S_DIR:=$HOME/.r8s}
: ${R8S_BIN:=$R8S_DIR/bin}
: ${VERBOSITY:=0}
set -e
set -u

if type "nsenter" > /dev/null; then
  if [ $VERBOSITY -gt '0' ]; then
    echo nsenter found
  fi
  if [ ! -e $R8S_BIN/nsenter ]; then
    ln -s $(which nsenter) $R8S_BIN/nsenter
    if [ $VERBOSITY -gt '0' ]; then
      ls -al $R8S_BIN/nsenter
    fi
  fi
else
  if [ $VERBOSITY -gt '0' ]; then
    echo "nsenter not found attempting to compile..."
  fi
    make -e $R8S_BIN/nsenter
fi
