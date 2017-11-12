#!/bin/sh

cd ~
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

nvm install stable

nvm alias default stable

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # load nvm
[ -s "$NVM_DIR/bash-completion" ] && \. "$NVM_DIR/bash_completion" # load nvm