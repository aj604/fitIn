#!/bin/sh

bash install-node.sh

bash npm install
bash npm run build

bash npm run test

echo "press enter to exit."
read -e 
