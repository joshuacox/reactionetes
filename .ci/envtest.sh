#!/bin/bash -l
printenv
PATH=~/.meteor:$PATH
which meteor
echo -n 'npm version: '
npm -v
which npm
echo -n 'node version: '
node -v
which node
nvm ls
nvm use --lts lts/carbon
echo PATH is $PATH
ls -alh "$HOME/"|grep nvm
ls -lh "$HOME/.nvm"
echo doubledown
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm ls
nvm use --lts lts/carbon
echo -n 'npm version: '
npm -v
which npm
echo -n 'node version: '
node -v
which node
