
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
******************************************************************************************************
TA's:
To test the server, please open up Terminal and cd to the directory this readme is located in.
i.e., if the repository is located under “~/Documents/”, then please perform this command:

cd ~/Documents/fitIn/server/

If our repo is somewhere else, please make the necessary changes.
i.e. if our repo is located under "~/Documents/Group12/", then you would want to call

cd ~/Documents/Group12/server/

Once in the server directory, type in:

bash install-build.sh

This command will install and build the server, finally:

bash run-tests.sh

will run some unit tests, and then run a single iteration of the server.
run-tests.sh can be run as many times as you wish, but the other scripts should only be run once.
******************************************************************************************************
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The install-build.sh script will:
 1. download and install nvm
 2. download and install node and npm
 3. download all necessary dependancies
 4. compile the typescript source to javascript
 
The run-tests.sh script will:
 1. run some unit tests using mocha and chai
 2. run a single iteration of the server, displaying some output on success/failure.

If you have some experience with node, npm, or nvm, and wish to poke around our server some more,
you need to prefix all commands with "bash ", as a workaround for the permissions on the CSIL macs.
These commands only work in this folder, as they are bash scripts wrapping the true commands.
some examples:

bash nvm install latest
bash npm install
bash npm run build
bash node main.js
